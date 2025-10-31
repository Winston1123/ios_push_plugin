## 0.0.1

* Initial release of `ios_push_plugin`.
* Provides basic iOS push notification support:
  * Initialize push service (`initPush`)
  * Get device registration ID (`getRegId`)
  * Get platform version (`getPlatformVersion`)
  * Get device manufacturer (`getManufacturer`)
  * Enable or disable plugin logs (`enableLog`)
  * Set notification click callback (`setOnClickNotification`)
* Supports future extension for subscribing to topics, requesting permissions, and handling foreground notifications.

## 0.0.2

* Removed redundant code to simplify the plugin implementation.
* Internal improvements for cleaner and more maintainable code.
