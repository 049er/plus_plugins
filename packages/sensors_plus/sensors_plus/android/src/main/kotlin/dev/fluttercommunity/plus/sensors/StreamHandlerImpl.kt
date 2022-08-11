package dev.fluttercommunity.plus.sensors

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink

internal class StreamHandlerImpl(
        private val sensorManager: SensorManager,
        sensorType: Int
) : EventChannel.StreamHandler {
    
    private var sensorEventListener: SensorEventListener? = null

    private val sensor: Sensor by lazy {
        sensorManager.getDefaultSensor(sensorType)
    }

    override fun onListen(arguments: Any?, events: EventSink) {

        sensorEventListener = createSensorEventListener(events)

        // val sensorSampleRate = arguments as? Int ?: SensorManager.SENSOR_DELAY_FASTEST
        
        sensorManager.registerListener(sensorEventListener, sensor, SensorManager.SENSOR_DELAY_FASTEST)
    }

    override fun onCancel(arguments: Any?) {
        sensorManager.unregisterListener(sensorEventListener)
    }

    private fun createSensorEventListener(events: EventSink): SensorEventListener {
        return object : SensorEventListener {
            override fun onAccuracyChanged(sensor: Sensor, accuracy: Int) {}

            override fun onSensorChanged(event: SensorEvent) {
                val sensorValues = DoubleArray(event.values.size + 1)
                event.values.forEachIndexed { index, value ->
                    sensorValues[index] = value.toDouble()
                }
                sensorValues[event.values.size] = event.timestamp.toDouble()
                events.success(sensorValues)
           
            }
        }
    }
}
