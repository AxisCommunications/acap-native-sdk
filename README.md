# Overview
SDK for building low level ACAP applications in C or C++

## API Versions
The table below shows API and firmware version compatibility.

| API Version | Firmware | Comment|
| ---------------- | ------------- |------------- |
| 1.0-alpha1      | 10.5         | Initial version forked from acap3-sdk |
| latest       | 10.6         | Updated APIs and toolchain from legacy SDK 3.4|

# APIs
The following APIs are supported:
  * AxEvent
  * AxOverlay
  * Cairo
  * Larod
  * Licensekey
  * OpenCL
  * Vdo

# Languages
* C
* C++

# Examples
## Classic ACAP application
Building a classic ACAP example with ACAP Native SDK:
```bash
docker build . --tag native_example_application --build-arg VERSION=1.0_alpha1 --build-arg SDK=acap-native-sdk
```

Classic application examples supported by ACAP Native SDK:
* [axevent](https://github.com/AxisCommunications/acap3-examples/tree/master/axevent/)
* [axoverlay](https://github.com/AxisCommunications/acap3-examples/tree/master/axoverlay/)
* [larod](https://github.com/AxisCommunications/acap3-examples/tree/master/larod/)
* [licensekey](https://github.com/AxisCommunications/acap3-examples/tree/master/licensekey/)
* [object-detection](https://github.com/AxisCommunications/acap3-examples/blob/master/object-detection)
* [tensorflow-to-larod](https://github.com/AxisCommunications/acap3-examples/tree/master/tensorflow-to-larod/)
* [using-opencv](https://github.com/AxisCommunications/acap3-examples/tree/master/using-opencv/)
* [vdostream](https://github.com/AxisCommunications/acap3-examples/tree/master/vdostream/)
* [vdo-larod](https://github.com/AxisCommunications/acap3-examples/tree/master/vdo-larod/)
* [vdo-larod-preprocessing](https://github.com/AxisCommunications/acap3-examples/tree/master/vdo-larod-preprocessing/)
* [vdo-opencl-filtering](https://github.com/AxisCommunications/acap3-examples/blob/master/vdo-opencl-filtering/)

## Container based application
Container based application examples supported by ACAP Native SDK:
* [opencl-fft](https://github.com/AxisCommunications/acap-application-examples/tree/master/opencl-fft/)

# License
By downloading ACAP Native SDK you automatically agree to the terms in the [license agreement](https://www.axis.com/techsup/developer_doc/EULA/LICENSE.pdf)

ACAP Native SDK open source licenses and copyleft source code are found [here](http://acap-artifacts.s3-website.eu-north-1.amazonaws.com/)
