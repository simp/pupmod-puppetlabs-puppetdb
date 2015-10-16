Summary: PuppetLabs PuppetDB Module
Name: puppetlabs-puppetdb
Version: 5.0.0
Release: 0
License: Apache License, 2.0
Group: Applications/System
Source: %{name}-%{version}-%{release}.tar.gz
Buildroot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Requires: puppet >= 3.3.2
Buildarch: noarch
Requires: simp-bootstrap >= 4.2.0
Obsoletes: pupppetlabs-puppetdb-test

Prefix: /etc/puppet/environments/simp/modules

%description
This is the puppetlabs puppetdb module as hosted at
https://github.com/puppetlabs/puppetlabs-puppetdb.

%prep
%setup -q

%build

%install
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/puppetdb

dirs='files lib manifests templates'
for dir in $dirs; do
  test -d $dir && cp -r $dir %{buildroot}/%{prefix}/puppetdb
done

%clean
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/puppetdb

%files
%defattr(0640,root,puppet,0750)
%{prefix}/puppetdb

%post
#!/bin/sh

%postun
# Post uninstall stuff

%changelog
* Fri Oct 16 2015 Nick Markowski <nmarkowski@keywcorp.com> - 5.0.0-0
- Initial commit of 5.0.0 release.
- The module now supports PuppetDB 2 and 3.
- Modified the default postgresql_version param to be undef.

* Tue May 05 2015 Nick Markowski <nmarkowski@keywcorp.com> - 4.1.0-1
- Ensured '/etc/puppet/puppetdb.conf' present; was not present in the
  catalog otherwise.

* Mon Feb 02 2015 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.1.0-0
- Initial rollup of the 4.1.0 release
