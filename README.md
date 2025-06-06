## mix nova.new

Provides `nova.new` installer as an archive.

To install from Hex, run:

    $ mix archive.install hex nova_new

To build and install it locally,
ensure any previous archive versions are removed:

    $ mix archive.uninstall nova_new

Then run:

    $ mix do archive.build, archive.install
