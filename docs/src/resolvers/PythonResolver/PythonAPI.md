

## Overview
You can import the Python module as follows:

[ 您可以按如下方式导入 Python 模块]
```python
from pxr import Ar
from usdAssetResolver import PythonResolver
```

## Tokens
Tokens can be found in PythonResolver.Tokens:

[ Tokens 可以在 PythonResolver.Tokens 中找到]
```python
PythonResolver.Tokens.mappingPairs
PythonResolver.Tokens.mappingRegexExpression
PythonResolver.Tokens.mappingRegexFormat
PythonResolver.Tokens.searchPaths
```

## Resolver Context
You can manipulate the resolver context (the object that holds the configuration the resolver uses to resolve paths) via Python in the following ways:

[ 您可以使用 Python 通过以下方式操作解析器上下文（保存解析器用于解析路径的配置的对象）]

```python
from pxr import Ar, Usd
from usdAssetResolver import PythonResolver

# Get via stage
stage = Usd.Stage.Open("/some/stage.usd")
context_collection = stage.GetPathResolverContext()
pythonResolver_context = context_collection.Get()[0]
# Or context creation
pythonResolver_context = PythonResolver.ResolverContext()

# To print a full list of exposed methods:
for attr in dir(PythonResolver.ResolverContext):
    print(attr)
```

### Refreshing the Resolver Context
```admonish important
If you make changes to the context at runtime, you'll need to refresh it!

[ 如果您在运行时更改上下文，则需要刷新它！]
```
You can reload it as follows, that way the active stage gets the change notification.

[ 您可以按如下方式重新加载它，这样激活 stage 就会收到更改通知]

```python
from pxr import Ar
from usdAssetResolver import PythonResolver
resolver = Ar.GetResolver()
stage = pxr.Usd.Stage.Open("/some/stage.usd")
context_collection = stage.GetPathResolverContext()
pythonResolver_context = context_collection.Get()[0]
# Make edits as described below to the context.
pythonResolver_context.SetData("{'mappingPairs': {'source.usd': 'destination.usd'}, 'searchPaths': ['/path/A']}")
# Trigger Refresh (Some DCCs, like Houdini, additionally require node re-cooks.)
resolver.RefreshContext(context_collection)
```

### Editing the Resolver Context
Since the resolver is implemented in Python, the actual context data is a serialized json dict.
It can be retrieved/edited/set as follows:

[ 由于解析器是用 Python 实现的，因此实际的上下文数据是序列化的 json 字典. 可以按如下方式检索/编辑/设置]

```python
import json
stage = pxr.Usd.Stage.Open("/some/stage.usd")
context_collection = stage.GetPathResolverContext()
pythonResolver_context = context_collection.Get()[0]
# Load context
data = json.loads(pythonResolver_context.GetData())
# Manipulate data
data[PythonResolver.Tokens.mappingPairs]["sourceAdd.usd"] = "targetAdd.usd"
# Set context
pythonResolver_context.SetData(json.dumps(data))
# Trigger Refresh (Some DCCs, like Houdini, additionally require node re-cooks.)
resolver.RefreshContext(context_collection)
```

When the context is initialized for the first time, it runs the `ResolverContext.LoadOrRefreshData` method as described below. After that is is just a serialized .json dict with at minimum the `PythonResolver.Tokens.mappingPairs`and `PythonResolver.Tokens.searchPaths` tokens being set.

[ 当上下文第一次初始化时，它将运行 `ResolverContext.LoadOrRefreshData` 方法，之后只是一个序列化的 .json 字典，至少设置了 `PythonResolver.Tokens.mappingPairs` 和 `PythonResolver.Tokens.searchPaths` 标记]

Additionally the `PythonResolver.Tokens.mappingRegexExpression`/`PythonResolver.Tokens.mappingRegexFormat` keys can be set to support regex substitution before doing the mapping pair lookup.

[ 此外可以将 `PythonResolver.Tokens.mappingRegexExpression` / `PythonResolver.Tokens.mappingRegexFormat` 键设置为在进行映射对查找之前支持正则表达式替换]

### PythonExpose.py Overview

The rest of the Python API is actually the fully exposed resolver.

[ Python API 的其余部分实际上是完全公开的解析器]

You can find the fully implemented version that gets shipped with the compiled code here:
[PythonExpose.py](https://github.com/LucaScheller/VFX-UsdAssetResolver/blob/main/src/PythonResolver/PythonExpose.py). This file has feature parity to the [File Resolver](../FileResolver/overview.md). It is also quite close to the native default file resolver that ships with Usd.

[ 您可以在此处找到随编译代码一起提供的完全实现的版本：[PythonExpose.py](https://github.com/LucaScheller/VFX-UsdAssetResolver/blob/main/src/PythonResolver/PythonExpose.py) 该文件具有与文件解析器相同的功能, 它也非常接近于 Usd 附带的默认[File Resolver](../FileResolver/overview.md)]

```admonish important
You can live edit it after the compilation here: `${REPO_ROOT}/dist/pythonResolver/lib/python/PythonExpose.py`.
Since the code just looks for the `PythonExpose.py` file anywhere in the `sys.path` you can also move or re-create the file anywhere in the path to override the behaviour. The module name can be controlled by the `CMakeLists.txt` file in the repo root by setting `AR_PYTHONRESOLVER_USD_PYTHON_EXPOSE_MODULE_NAME` to a different name.

[ 您可以在编译后对其进行实时编辑：`${REPO_ROOT}/dist/pythonResolver/lib/python/PythonExpose.py` 由于代码只是在 `sys.path` 中的任何位置查找 `PythonExpose.py` 文件，因此您还可以在路径中的任何位置移动或重新创建该文件以覆盖该行为 通过将 `AR_PYTHONRESOLVER_USD_PYTHON_EXPOSE_MODULE_NAME` 设置为不同的名称，可以通过存储库根目录中的 `CMakeLists.txt` 文件来控制模块名称]
```

Below we show the Python exposed methods, note that we use static methods, as we just call into the module and don't create the actual object. (This module could just as easily been made up of pure functions, we just create the classes here to make it match the C++ API.)

[ 下面我们展示了 Python 公开的方法，请注意，我们使用静态方法，因为我们只是调用模块而不创建实际的对象 （这个模块可以很容易地由纯函数组成，我们只需在此处创建类以使其与 C++ API 匹配）]

The method signatures match the C++ signatures, except how the context is injected, as this is necessary due to how the Python exposing works.

[ 方法签名与 C++ 签名匹配，但上下文的注入方式除外，因为由于 Python 公开的工作方式，这是必要的]

To enable a similar logging as the `TF_DEBUG` env var does, you can uncomment the following in the `log_function_args` function.

[ 要启用与 `TF_DEBUG` 环境变量类似的日志记录，您可以取消注释 `log_function_args` 函数中的以下内容]

```python
...code...
def log_function_args(func):
    ...code...
    # To enable logging on all methods, re-enable this.
    # LOG.info(f"{func.__module__}.{func.__qualname__} ({func_args_str})")
...code...
```

#### Resolver

```python
class Resolver:
    @staticmethod
    def _CreateIdentifier(assetPath, anchorAssetPath, serializedContext, serializedFallbackContext):
        """Returns an identifier for the asset specified by assetPath.
        If anchorAssetPath is not empty, it is the resolved asset path
        that assetPath should be anchored to if it is a relative path.
        Args:
            assetPath (str): An unresolved asset path.
            anchorAssetPath (Ar.ResolvedPath): An resolved anchor path.
            serializedContext (str): The serialized context.
            serializedFallbackContext (str): The serialized fallback context.
        Returns:
            str: The identifier.
        """
        ... code ...
    @staticmethod
    def _CreateIdentifierForNewAsset(assetPath, anchorAssetPath):
        """Return an identifier for a new asset at the given assetPath.
        This is similar to _CreateIdentifier but is used to create identifiers
        for assets that may not exist yet and are being created.
        Args:
            assetPath (str): An unresolved asset path.
            anchorAssetPath (Ar.ResolvedPath): An resolved anchor path.
        Returns:
            str: The identifier.
        """
        ... code ...
    @staticmethod
    def _Resolve(assetPath, serializedContext, serializedFallbackContext):
        """Return the resolved path for the given assetPath or an empty
        ArResolvedPath if no asset exists at that path.
        Args:
            assetPath (str): An unresolved asset path.
        Returns:
            Ar.ResolvedPath: The resolved path.
        """
        ... code ...
    @staticmethod
    def _ResolveForNewAsset(assetPath):
        """Return the resolved path for the given assetPath that may be
        used to create a new asset or an empty ArResolvedPath if such a
        path cannot be computed.
        Args:
            assetPath (str): An unresolved asset path.
        Returns:
            Ar.ResolvedPath: The resolved path.
        """
        ... code ...
    @staticmethod
    def _IsContextDependentPath(assetPath):
        """Returns true if assetPath is a context-dependent path, false otherwise.
        Args:
            assetPath (str): An unresolved asset path.
        Returns:
            bool: The context-dependent state.
        """
        ... code ...
    @staticmethod
    def _GetModificationTimestamp(assetPath, resolvedPath):
        """Return an ArTimestamp representing the last time the asset at assetPath was modified.
        Args:
            assetPath (str): An unresolved asset path.
            resolvePath (Ar.ResolvedPath): A resolved path.
        Returns:
            Ar.Timestamp: The timestamp.
        """
        ... code ...
```

#### Resolver Context

```python
class ResolverContext:
    @staticmethod
    def LoadOrRefreshData(mappingFilePath, searchPathsEnv, mappingRegexExpressionEnv, mappingRegexFormatEnv):
        """Load or refresh the mapping pairs from file and the search paths from the
        configured environment variables.
        Args:
            mappingFilePath(str): The mapping .usd file path
            searchPathsEnv(str): The search paths environment variable
            mappingRegexExpressionEnv(str): The mapping regex expression environment variable
            mappingRegexFormatEnv(str): The mapping regex format environment variable
        Returns:
            str: A serialized json dict that can be used as a context.
        """
        ... code ...
```