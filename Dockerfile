# Qvd Image based on Docker
# Copyright (C) 2015  theqvd.com trade mark of Qindel Formacion y Servicios SL
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

FROM ubuntu:16.04
MAINTAINER The QVD <docker@theqvd.com>

LABEL version="1.0"
LABEL description="This is minimal Ubuntu VM image installation for QVD. Only an xterm is included"

EXPOSE 3030 4100

ENV DEBIAN_FRONTEND noninteractive
# QVD Repository and QVD VMA packages
RUN apt-get update && \
   apt-get install -y wget && \
   wget -qO - http://theqvd.com/packages/key/public.key | apt-key add - && \
   echo "deb http://theqvd.com/packages/ubuntu-xenial QVD-4.0.0 main" > /etc/apt/sources.list.d/qvd-40.list && \
   apt-get update && \
   apt-get install -y perl-qvd-vma linux-headers-generic-  plymouth-disabler ifupdown iproute2 && \
   apt-get --purge remove -y xserver-xorg linux-image-generic linux-headers-generic && \
   apt-get autoremove -y && apt-get clean && \
   mkdir -p /etc/udev/rules.d/ && echo "" > /etc/udev/rules.d/70-persistent-net.rules
RUN mkdir -p /etc/qvd
COPY vma.conf /etc/qvd/vma.conf
# System config
COPY interfaces /etc/network/interfaces.d/qvdinterface
COPY etc_init_ttyS0.conf /etc/init/ttyS0.conf
COPY manual /etc/init/rsyslog.override
COPY manual /etc/init/cron.override
COPY journald.conf /etc/systemd/journald.conf
# Hack for Docker backends in QVD
COPY VMA.pm /usr/lib/qvd/lib/perl5/site_perl/5.14.2/QVD/VMA.pm
COPY Defaults.pm /usr/lib/qvd/lib/perl5/site_perl/5.14.2/QVD/Config/Core/Defaults.pm
# CMD
CMD /usr/lib/qvd/bin/perl /usr/lib/qvd/bin/qvd-vma.pl -X
