<VirtualHost *:>
    ServerName segundosauxilios.com
    ServerAlias www.segundosauxilios.com
    DocumentRoot /home/backends/refuge_stage/public
      <Location />
                PassengerRuby /home/ruby3k/.rvm/wrappers/ruby-2.3.0/ruby
                PassengerBaseURI /
        </Location>
</VirtualHost>