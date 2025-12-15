# Resolvers
Asset resolvers that can be compiled via this repository:

[ 可以通过此存储库编译的资产解析器]
{{#include ./shared_features.md:resolverOverview}}

## USD Plugin Configuration [USD插件配置]
In order for our plugin to be found by USD, we have to specify a few environment variables.
Run this in your terminal before running your USD capable app. If your are using a pre-compiled release build, redirect the paths accordingly.

[ 为了使 USD 能够找到我们的插件，我们需要指定一些环境变量. 在运行支持 USD 的应用程序之前，请在您的终端中运行以下命令. 如果您使用的是预编译的发布版本，请相应地重定向路径]

~~~admonish tip
If you are using our quick install method, this will already have been done for you via the "launch.sh/.bat" file in the directory where you downloaded the compiled release to. See our [Automatic Installation](../installation/automatic_install.md) section for more information.

[ 如果您使用的是我们的快速安装方法，那么这些操作已经通过您下载编译后的发布版本所在的目录中的“launch.sh/.bat”文件为您完成了. 请参阅我们的 [自动安装](../installation/automatic_install.md) 部分以获取更多信息]
~~~

~~~admonish info title=""
```bash
# Linux
export PYTHONPATH=${REPO_ROOT}/dist/${RESOLVER_NAME}/lib/python:${PYTHONPATH}
export PXR_PLUGINPATH_NAME=${REPO_ROOT}/dist/${RESOLVER_NAME}/resources:${PXR_PLUGINPATH_NAME}
export LD_LIBRARY_PATH=${REPO_ROOT}/dist/${RESOLVER_NAME}/lib
export TF_DEBUG=AR_RESOLVER_INIT # Debug Logs
# Windows
set PYTHONPATH=%REPO_ROOT%\dist\%RESOLVER_NAME%\lib\python;%PYTHONPATH%
set PXR_PLUGINPATH_NAME=%REPO_ROOT%\dist\%RESOLVER_NAME%\resources;%PXR_PLUGINPATH_NAME%
set PATH=%REPO_ROOT%\dist\%RESOLVER_NAME%\lib;%PATH%
set TF_DEBUG=AR_RESOLVER_INIT # Debug Logs
```
~~~

If it loads correctly, you'll see something like this in the terminal output:

[ 如果加载正确，您将在终端输出中看到类似以下内容]
~~~admonish info title=""
```bash
ArGetResolver(): Found primary asset resolver types: [FileResolver, ArDefaultResolver]
```
~~~

## Debugging [调试]
### By using the `TF_DEBUG` environment variable
To check what resolver has been loaded, you can set the `TF_DEBUG` env variable to `AR_RESOLVER_INIT`:

[ 要检查已加载的解析器，您可以将 TF_DEBUG 环境变量设置为 AR_RESOLVER_INIT ]
~~~admonish info title=""
```bash
export TF_DEBUG=AR_RESOLVER_INIT
```
~~~
For example this will yield the following when run with the Python Resolver:

[ 例如，当使用 Python Resolver 运行时，将产生以下结果]
~~~admonish info title=""
```python
ArGetResolver(): Found primary asset resolver types: [PythonResolver, ArDefaultResolver]
ArGetResolver(): Using asset resolver PythonResolver from plugin ${REPO_ROOT}/dist/pythonResolver/lib/pythonResolver.so for primary resolver
ArGetResolver(): Found URI resolver ArDefaultResolver
ArGetResolver(): Found URI resolver FS_ArResolver
ArGetResolver(): Using FS_ArResolver for URI scheme(s) ["op", "opdef", "oplib", "opdatablock"]
ArGetResolver(): Found URI resolver PythonResolver
ArGetResolver(): Found package resolver USD_NcPackageResolver
ArGetResolver(): Using package resolver USD_NcPackageResolver for usdlc from plugin usdNc
ArGetResolver(): Using package resolver USD_NcPackageResolver for usdnc from plugin usdNc
ArGetResolver(): Found package resolver Usd_UsdzResolver
ArGetResolver(): Using package resolver Usd_UsdzResolver for usdz from plugin usd
```
~~~

### By loading the Python Module [通过Python模块加载]
When importing the Python module, be sure to first import the Ar module, otherwise you might run into errors, as the resolver is not properly initialized:

[ 导入 Python 模块时，请务必先导入 Ar 模块，否则可能会遇到错误，因为解析器未正确初始化]
~~~admonish info title=""
```bash
# Start python via the aliased `usdpython`
# Our sourced setup.sh aliases Houdini's standalone python to usdpython
# as well as sources extra libs like Usd
usdpython
```
~~~
~~~admonish info title=""
```python
# First import Ar, so that the resolver is initialized
from pxr import Ar
from usdAssetResolver import FileResolver
```
~~~