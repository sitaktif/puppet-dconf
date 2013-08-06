puppet-dconf
============

Edit dconf configuration with puppet


Usage
-----

Because of current limitations, a certain level of quoting/escaping needs to be done on the 'value' parameter. The easiest is to give some examples.

Example with a bool (no quoting/escaping needed) ::

    dconf::set { "/com/canonical/indicator/datetime/show-date":
            value => "true",
            user => "myuser",
            group => "mygroup",
    }

Example with a string (add quotes) ::

    dconf::set { "/org/gnome/settings-daemon/peripherals/touchpad/scroll-method":
            value => "'two-finger-scrolling'",
    }

Example with a list (escape backslashes) ::

    dconf::set { "/org/gnome/libgnomekbd/keyboard/options":
	    value => "['ctrl\\tctrl:nocaps']",
    }


Notes
-----

* Apart from the quoting/escaping, make sure that the 'key' begins with a slash and does *not* end with slash.
* An easy way to dump your dconf configuration ::

        $ dconf dump /
