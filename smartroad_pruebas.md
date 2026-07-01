# Taller – Diseño de pruebas del sistema y pruebas especializadas

## Proyecto: SmartRoad S.O.S.

Autores:
- Daniel Di Marco
- Angie Carrillo
- Felipe Carrillo
- Oswal Wscanga

## 1. Introducción

SmartRoad S.O.S. es un sistema tecnológico diseñado para detectar signos de somnolencia y fatiga en conductores mediante visión artificial y procesamiento de imágenes en tiempo real. El sistema monitorea continuamente el comportamiento del conductor, identificando señales como el cierre prolongado de los ojos o la inclinación de la cabeza, y genera alertas preventivas con el fin de reducir el riesgo de accidentes de tránsito.

## 2. Objetivo general de las pruebas

Validar que SmartRoad S.O.S. cumpla con los requisitos funcionales y no funcionales definidos, garantizando un funcionamiento confiable, seguro y eficiente durante la detección de somnolencia en conductores.

## 3. Pruebas del sistema

### 3.1 Prueba de funcionalidades

**Objetivo**
Verificar que todas las funcionalidades implementadas en SmartRoad S.O.S. operen correctamente de acuerdo con los requerimientos establecidos.

**Funcionalidades evaluadas**
- Detección de cierre prolongado de ojos
- Detección de inclinación de cabeza
- Monitoreo continuo mediante cámara
- Generación de alertas sonoras
- Generación de alertas visuales
- Registro de eventos detectados
- Generación de reportes
- Encendido automático del sistema
- Configuración de alertas
- Almacenamiento de historial de eventos

**Caso de prueba**
- **Código:** PF-001
- **Nombre:** Detección de somnolencia
- **Entrada:** El conductor simula el cierre prolongado de ojos
- **Proceso:** El sistema analiza la imagen capturada
- **Resultado esperado:** Se activa una alerta sonora y visual
- **Criterio de éxito:** El sistema debe detectar correctamente los signos de somnolencia y emitir alertas en menos de 2 segundos

### 3.2 Prueba de integración

**Objetivo**
Verificar la correcta comunicación e interacción entre todos los componentes del sistema.

**Componentes integrados**
- Cámara
- ESP32
- Sistema de alertas
- Base de datos
- Módulo de reportes

**Caso de prueba**
- **Código:** PI-001
- **Nombre:** Integración completa del sistema
- **Entrada:** Simulación de conductor con fatiga
- **Proceso:** La cámara captura imagen y envía datos al sistema
- **Resultado esperado:** Procesamiento correcto y generación de alerta
- **Criterio de éxito:** Todos los módulos deben comunicarse correctamente sin pérdida de información ni interrupciones

### 3.3 Prueba del sistema

**Objetivo**
Evaluar el comportamiento general de SmartRoad S.O.S. en un escenario real de conducción.

**Escenario de prueba**
El conductor utiliza el vehículo durante un recorrido continuo mientras el sistema monitorea permanentemente su comportamiento.

**Caso de prueba**
- **Código:** PS-001
- **Nombre:** Funcionamiento completo
- **Entrada:** Simulación de conducción real
- **Proceso:** Monitoreo permanente durante el recorrido
- **Resultado esperado:** Detección de fatiga y emisión de alertas
- **Criterio de éxito:** El sistema debe funcionar de manera continua sin interrupciones durante todo el trayecto

## 4. Pruebas especializadas

### 4.1 Prueba de rendimiento

**Objetivo**
Determinar la capacidad del sistema para procesar imágenes y responder oportunamente ante señales de somnolencia.

**Aspectos evaluados**
- Tiempo de procesamiento de imágenes
- Tiempo de generación de alertas
- Consumo de memoria
- Consumo de procesador

**Caso de prueba**
- **Código:** PR-001
- **Nombre:** Tiempo de respuesta
- **Entrada:** Flujo continuo de imágenes
- **Proceso:** Procesamiento en tiempo real
- **Resultado esperado:** Respuesta menor a 2 segundos
- **Criterio de éxito:** El sistema debe emitir alertas en un tiempo inferior a 2 segundos

### 4.2 Prueba de seguridad

**Objetivo**
Validar que la información almacenada y los componentes del sistema estén protegidos contra accesos no autorizados.

**Aspectos evaluados**
- Acceso a registros de eventos
- Protección de la base de datos
- Restricción de usuarios no autorizados
- Integridad de la información almacenada

**Caso de prueba**
- **Código:** PSE-001
- **Nombre:** Control de acceso
- **Entrada:** Intento de acceso sin autorización
- **Proceso:** Validación de credenciales
- **Resultado esperado:** Acceso denegado
- **Criterio de éxito:** Ningún usuario no autorizado debe acceder a la información del sistema

## 5. Recursos utilizados para las pruebas

### Hardware
- Cámara de monitoreo
- ESP32
- Sensor de apoyo
- Computador portátil
- Dispositivo de alertas (buzzer y LEDs)

### Software
- Python / Node.js
- OpenCV
- Visual Studio Code
- Sistema Operativo Windows
- PlantUML
- Base de datos del proyecto

## 6. Resultados esperados

- Detección precisa de signos de somnolencia
- Generación inmediata de alertas
- Registro correcto de eventos
- Funcionamiento continuo del sistema
- Integración estable entre todos los módulos
- Protección adecuada de los datos almacenados

## 7. Riesgos identificados

| Riesgo | Impacto | Mitigación |
|---|---|---|
| Falsas detecciones | Alto | Ajustar algoritmos de visión artificial |
| Fallo de la cámara | Alto | Mantenimiento preventivo |
| Baja iluminación | Medio | Uso de cámara con visión nocturna |
| Fallo del ESP32 | Alto | Pruebas constantes del hardware |
| Pérdida de datos | Medio | Copias de seguridad periódicas |

## 8. Criterios de aprobación

Las pruebas serán consideradas exitosas cuando:
- El sistema detecte correctamente los signos de somnolencia
- Las alertas se generen en menos de 2 segundos
- La integración entre módulos funcione correctamente
- No existan errores críticos durante las pruebas
- La información almacenada permanezca protegida
- El sistema opere de forma continua durante el tiempo establecido

## 9. Conclusiones

Las pruebas diseñadas para SmartRoad S.O.S. permitirán validar la funcionalidad, integración, rendimiento y seguridad del sistema antes de su implementación. La ejecución de estas pruebas garantizará que la solución tecnológica cumpla con su objetivo principal: contribuir a la prevención de accidentes de tránsito causados por la somnolencia de los conductores mediante una detección temprana y generación oportuna de alertas.
