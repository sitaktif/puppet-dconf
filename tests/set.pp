dconf::set { "/com/canonical/indicator/datetime/show-date":
    value => "true",
    user => 'myuser',
    group => 'usergroup',
}

dconf::set { 'org/gnome/settings-daemon/peripherals/touchpad/scroll-method':
	value => "'two-finger-scrolling'",
}

dconf::set { '/org/gnome/libgnomekbd/keyboard/options':
	#value => "\\\"['ctrl\\tctrl:nocaps']\\\"",
	value => '\\"[\'ctrl\tctrl:nocaps\']\\"',
}

