# Galeb

Galeb is a dynamic software router built on JBOSS Undertow and XNIO.
It's a massively parallel routing system running a shared-nothing architecture.

Its main features are:

- Open Source
- API REST (management)
- Allows dynamically change routes and configuration without having to restart or reload
- Highly scalable
- Masterless (SNA - Shared nothing architecture)
- Sends metrics to external counters (eg statsd)

## Requisites

- docker
- docker-compose

## Building docker images

```bash
./build-galeb.sh
```

## Starting services

```bash
./start.sh
```

## Stopping services

```bash
./stop.sh
```

## Testing

```bash
curl -H"Host: lol.localdomain" $(./ip-router.sh):8080
```

## License

```Copyright
Copyright (c) 2014-2015 Globo.com - ATeam All rights reserved.

 This source is subject to the Apache License, Version 2.0.
 Please see the LICENSE file for more information.

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 ```
