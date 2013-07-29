class web{
    file {
        "/tmp/test":
             content=>"hello web",
             mode=> 0644;
    }
    package { "nginx":
        ensure => installed
    }
}

class mysql{
     file {
          "/tmp/mysql":
               content => "mysql\n"
     }
     package{ "mysql-server":
              ensure => installed
     }
}
