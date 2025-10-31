package com.example.flutter_application_1

import android.content.Context
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)

		// 尝试在支持的设备上选择 120Hz（或更高）的显示模式。
		// 使用 WindowManager + Display.getSupportedModes()，然后设置
		// WindowManager.LayoutParams.preferredDisplayModeId。仅在 API 23+ 可用。
		try {
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
				val wm = getSystemService(Context.WINDOW_SERVICE) as WindowManager
				val display = wm.defaultDisplay
				val modes = display.supportedModes
				// 查找第一个刷新率 >= 119 的模式（接近 120Hz）
				val preferred = modes.firstOrNull { it.refreshRate >= 119.0f }
				if (preferred != null) {
					val lp = window.attributes
					lp.preferredDisplayModeId = preferred.modeId
					window.attributes = lp
				}
			}
		} catch (e: Exception) {
			// 如果设备或 ROM 不支持这些 API，静默失败并继续
			e.printStackTrace()
		}
	}
}
