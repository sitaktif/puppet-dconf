# It is a bit messy because of the use of eval but the idea is there:
# * `dbus-launch --auto-syntax` sets some environment vars
# * `dconf write` writes the conf
#
# Note: `value` needs to be escaped in a non-intuitive way. See the examples in the README.

define dconf::set ($value,$user,$group) {
	include dconf

	debug "Dconf: set $name to $value for user $user and group $group"

	exec { "dconf set $name":
		command => "/bin/sh -c 'eval `dbus-launch --auto-syntax`'\" && dconf write $name \\\"$value\\\"\"",
		path => "/usr/bin",
		onlyif => "/bin/sh -c 'eval `dbus-launch --auto-syntax`'\" && test \\\"$value\\\" != \\\"`dconf read $name`\\\"\"",
		logoutput => "true",
		require => Package['dconf-tools'],
		user => $user,
		group => $group,
		environment => "XDG_RUNTIME_DIR=/run/user/$user",
	}
}
