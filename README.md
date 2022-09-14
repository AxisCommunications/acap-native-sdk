# Overview
SDK for building low level ACAP applications in C or C++

## API Versions
The table below shows API and firmware version compatibility.

| API Version | Firmware | Comment|
| ---------------- | ------------- |------------- |
| 1.4_beta1 | 11.0 | API and Toolchain version 4.4_beta1 |
| 1.3 | 10.12 | API and Toolchain version 4.3 |
| 1.3_rc1 | 10.12 | API and Toolchain version 4.3_rc1 |
| 1.2 | 10.10 | API and Toolchain version 4.2 |
| 1.1 | 10.9 | API and Toolchain version 4.1 |
| 1.1_beta1 | 10.9 | API and Toolchain version 4.1_beta1 |
| 1.0              | 10.7         | Updated API and Toolchain to 4.0|
| 1.0-beta2        | 10.7         | Updated API and Toolchain to 4.0_beta2|
| 1.0-beta1        | 10.6         | Updated API to 3.4 and Toolchain to 3.4.1_beta1|
| 1.0-alpha1       | 10.5         | Initial version forked from acap3-sdk |

# APIs
The following APIs are supported:
  * AxEvent
  * AxOverlay
  * Cairo
  * Larod
  * Licensekey
  * OpenCL
  * Vdo

# C++ Support
## C++ Standard Library
ACAP Native SDK uses [GNU C++ Standard Library (libstdc++)](https://gcc.gnu.org/onlinedocs/libstdc++/).

## C++ Version
We recommend ACAP application written in C++ to use either C++ version 11 or C++ version 17.

For more details about C++ support, see [C++ Standards Support in GCC](https://gcc.gnu.org/projects/cxx-status.html) and
[libstdc++ Implementation Status](https://gcc.gnu.org/onlinedocs/libstdc++/manual/status.html).

# Examples
Native ACAP Application examples are available on GitHub: [acap-native-sdk-examples](https://github.com/AxisCommunications/acap-native-sdk-examples)

# License
By downloading ACAP Native SDK you automatically agree to the terms in the [license agreement](https://www.axis.com/techsup/developer_doc/EULA/LICENSE.pdf)

ACAP Native SDK open source licenses and copyleft source code are found [here](http://acap-artifacts.s3-website.eu-north-1.amazonaws.com/)
