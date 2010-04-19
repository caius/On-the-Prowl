* Read twitter DMs
	* Read credentials from yaml file
	* Store last-read DM id
		* At run **without** stored DM id, **DON'T** act upon stored DMs, just take id of last one and store it
		* At run **with** stored DM id, act upon any received since
	* Filter DMs against a whitelist of accepted usernames

* Some sort of Notification centre
* Plugins register 
