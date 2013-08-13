class dconf {
        package { "dconf-tools":
                ensure => installed,
                require => Class["aptconf::debian-wheezy"],
        }
        file { "/etc/dconf/":
                ensure => directory,
                owner => 'root',
                group => 'root',
                mode => '0755',
        }
        file { "/etc/dconf/profile/":
                ensure => directory,
                owner => 'root',
                group => 'root',
                mode => '0755',
                require => File["/etc/dconf/"],
        }
        file { "/etc/dconf/profile/user":
                ensure => present,
                owner => 'root',
                group => 'root',
                mode => '0644',
                content => "user-db:user\nsystem-db:local\n",
                require => File["/etc/dconf/profile/"],
        }
        file { "/etc/dconf/db/":
                ensure => directory,
                owner => 'root',
                group => 'root',
                mode => '0755',
                require => File["/etc/dconf/"],
        }
        file { "/etc/dconf/db/local.d/":
                ensure => directory,
                owner => 'root',
                group => 'root',
                mode => '0755',
                require => File["/etc/dconf/db/"],
        }
        file { "/etc/dconf/db/local.d/locks/":
                ensure => directory,
                owner => 'root',
                group => 'root',
                mode => '0755',
                require => File["/etc/dconf/db/local.d/"],
        }
}

define dconf::keyfile($keypath,$key,$value,$user='root',$group='root',$lock=false) {
        include dconf
        file { "/etc/dconf/db/local.d/$key":
                ensure => present,
                owner => 'root',
                group => 'root',
                content => "[$keypath]\n$key=$value\n",
                notify => [ Exec["dconf update ($keypath/$key for $user)"], Exec["dconf update ($key for root)"] ],
        }
        exec { "dconf update ($keypath/$key for $user)":
                command => "/usr/bin/dconf update",
                user => $user,
                group => $group,
                refreshonly => true,
        }
        exec { "dconf update ($key for root)":
                command => "/usr/bin/dconf update",
                user => 'root',
                group => 'root',
                refreshonly => true,
        }
        if $lock == true {
                dconf::lockpref { "$keypath/$key":
                        keypath => $keypath,
                        key => $key
                }
        }
        else {
                dconf::unlockpref { "$keypath/$key":
                        keypath => $keypath,
                        key => $key,
                }
        }
}

define dconf::lockpref($keypath,$key) {
        file { "/etc/dconf/db/local.d/locks/$key":
                ensure => present,
                owner => 'root',
                group => 'root',
                mode => '0644',
                content => "/$keypath/$key\n",
                notify => Exec["dconf update lock ($key)"],
        }
        exec { "dconf update lock ($key)":
                command => "/usr/bin/dconf update",
                user => 'root',
                group => 'root',
                refreshonly => true,
        }
}
                
define dconf::unlockpref($keypath,$key) {
        file { "/etc/dconf/db/local.d/locks/$key":
                ensure => absent,
                notify => Exec["dconf update unlock ($key)"],
        }
        exec { "dconf update unlock ($key)":
                command => "/usr/bin/dconf update",
                user => 'root',
                group => 'root',
                refreshonly => true,
        }
}
