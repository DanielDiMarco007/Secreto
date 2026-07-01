import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/encryption_service.dart';
import '../services/firestore_service.dart';
import '../services/location_service.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final messageController = TextEditingController();
  String selectedPanel = 'a';
  bool isLoading = false;
  bool waitingForPersonB = false;
  bool searchingMessage = false;
  bool messageFound = false;
  String statusMessage = 'Elige un panel para comenzar';
  String? savedMessageText;
  String? foundMessageText;
  double? currentDistance;
  String? activeMessageId;
  double? targetLatitude;
  double? targetLongitude;

  StreamSubscription<Position>? _positionSubscription;

  @override
  void dispose() {
    messageController.dispose();
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> leaveSecretMessage() async {
    final message = messageController.text.trim();

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe un mensaje para dejarlo')),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
        statusMessage = 'Guardando el mensaje en tu ubicación...';
      });

      final position = await LocationService.getCurrentLocation();
      final encryptedMessage = EncryptionService.encrypt(message);

      final docId = await FirestoreService.createMessage(
        data: {
          'message': encryptedMessage,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'createdAt': DateTime.now().toIso8601String(),
          'isRead': false,
          'active': true,
          'status': 'pending',
        },
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
        waitingForPersonB = true;
        searchingMessage = false;
        messageFound = false;
        currentDistance = null;
        savedMessageText = message;
        activeMessageId = docId;
        targetLatitude = position.latitude;
        targetLongitude = position.longitude;
        selectedPanel = 'a';
        statusMessage =
            'Mensaje guardado. Persona A bloqueada hasta que Persona B lo encuentre.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mensaje guardado correctamente')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        statusMessage = 'No se pudo guardar el mensaje';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> startSearchForPersonB() async {
    try {
      setState(() {
        isLoading = true;
        statusMessage = 'Buscando el mensaje más reciente...';
      });

      final latestMessage = await FirestoreService.getLatestMessage();

      if (latestMessage == null ||
          latestMessage['latitude'] == null ||
          latestMessage['longitude'] == null) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
          statusMessage = 'Todavía no hay un mensaje activo para encontrar';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay mensaje activo todavía')),
        );
        return;
      }

      if (!mounted) return;

      final encryptedMessage = latestMessage['message'] as String?;

      setState(() {
        selectedPanel = 'b';
        searchingMessage = true;
        messageFound = false;
        foundMessageText = null;
        currentDistance = null;
        activeMessageId = latestMessage['id'] as String?;
        targetLatitude = (latestMessage['latitude'] as num).toDouble();
        targetLongitude = (latestMessage['longitude'] as num).toDouble();
        savedMessageText = encryptedMessage != null
            ? 'Mensaje listo para encontrar'
            : 'Mensaje listo para encontrar';
        statusMessage = 'Acércate a menos de 10 metros para ver el mensaje';
      });

      _positionSubscription?.cancel();
      _positionSubscription = LocationService.getPositionStream().listen(
        (position) async {
          if (targetLatitude == null || targetLongitude == null) return;

          final distance = LocationService.distanceInMeters(
            currentLat: position.latitude,
            currentLng: position.longitude,
            targetLat: targetLatitude!,
            targetLng: targetLongitude!,
          );

          if (!mounted) return;

          if (distance <= 10) {
            final decryptedMessage = _decryptFoundMessage(encryptedMessage);

            if (activeMessageId != null) {
              await FirestoreService.updateMessage(
                id: activeMessageId!,
                data: {'active': false, 'status': 'found', 'isRead': true},
              );
            }

            if (!mounted) return;

            setState(() {
              currentDistance = distance;
              isLoading = false;
              searchingMessage = true;
              messageFound = true;
              foundMessageText = decryptedMessage;
              statusMessage = '¡Mensaje encontrado!';
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('¡Mensaje encontrado!')),
            );
          } else {
            setState(() {
              currentDistance = distance;
              messageFound = false;
              foundMessageText = null;
              statusMessage =
                  'Acércate a menos de 10 metros para ver el mensaje';
            });
          }
        },
        onError: (error) {
          if (!mounted) return;
          setState(() {
            isLoading = false;
            statusMessage = 'No se pudo seguir la ubicación';
          });
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        statusMessage = 'No se pudo iniciar la búsqueda';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void resetRound() {
    _positionSubscription?.cancel();
    _positionSubscription = null;

    setState(() {
      selectedPanel = 'a';
      isLoading = false;
      waitingForPersonB = false;
      searchingMessage = false;
      messageFound = false;
      currentDistance = null;
      savedMessageText = null;
      foundMessageText = null;
      activeMessageId = null;
      targetLatitude = null;
      targetLongitude = null;
      messageController.clear();
      statusMessage = 'Listo para dejar otro mensaje';
    });
  }

  String? _decryptFoundMessage(String? encryptedMessage) {
    if (encryptedMessage == null || encryptedMessage.isEmpty) {
      return null;
    }

    try {
      return EncryptionService.decrypt(encryptedMessage);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.lock_outline, size: 70, color: AppTheme.purple),
              const SizedBox(height: 12),
              const Text(
                'SECRET DROP',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Modo de dos personas',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _panelButton(
                      title: 'Persona A',
                      icon: Icons.person_pin,
                      selected: selectedPanel == 'a',
                      onTap: () => setState(() => selectedPanel = 'a'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _panelButton(
                      title: 'Persona B',
                      icon: Icons.search,
                      selected: selectedPanel == 'b',
                      onTap: () => setState(() => selectedPanel = 'b'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: selectedPanel == 'a'
                    ? _buildPersonAPanel()
                    : _buildPersonBPanel(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonAPanel() {
    return Card(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Persona A',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Deja un mensaje secreto en tu posición exacta y bloquea el ciclo para Persona A.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Mensaje secreto',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.purple),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading || waitingForPersonB
                      ? null
                      : leaveSecretMessage,
                  icon: const Icon(Icons.send),
                  label: Text(
                    waitingForPersonB
                        ? 'Esperando a Persona B'
                        : 'Guardar mensaje',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (waitingForPersonB)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusMessage,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonBPanel() {
    return Card(
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Persona B',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Cuando Person A deje el mensaje, esta pantalla te llevará a su ubicación y lo marcará como encontrado entre 5 y 10 metros.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : startSearchForPersonB,
                  icon: const Icon(Icons.location_searching),
                  label: const Text('Buscar mensaje'),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusMessage,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    if (messageFound && foundMessageText != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.purple.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.purple.withOpacity(0.4),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mensaje encontrado',
                              style: TextStyle(
                                color: AppTheme.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              foundMessageText!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    else if (searchingMessage)
                      const Text(
                        'El mensaje solo aparece cuando estás a 10 metros o menos.',
                        style: TextStyle(color: Colors.white70),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: resetRound,
                      child: const Text('Nuevo ciclo'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => selectedPanel = 'a'),
                      child: const Text('Volver a Persona A'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _panelButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppTheme.purple : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
