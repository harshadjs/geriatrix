FROM debian

RUN apt-get update && apt-get install -y git cmake gcc g++ libboost-all-dev gdb

RUN mkdir /geriatrix

ADD profiles /geriatrix/profiles

ADD src /geriatrix/src

COPY CMakeLists.txt /geriatrix/CMakeLists.txt

RUN cd /geriatrix && mkdir build

RUN cd /geriatrix/build && cmake -DCMAKE_INSTALL_PREFIX=/opt -DCMAKE_PREFIX_PATH=/pkg ..

RUN cd /geriatrix/build && make -j 8 && make install

COPY geriatrix-runner.sh /geriatrix-runner.sh

ENTRYPOINT ["/geriatrix-runner.sh"]
