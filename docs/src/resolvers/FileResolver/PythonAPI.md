# Python API
## Overview [概述]
You can import the Python module as follows:

[ 您可以按如下方式导入 Python 模块]
```python
from pxr import Ar
from usdAssetResolver import FileResolver
```

## Tokens [令牌]
Tokens can be found in FileResolver.Tokens:

[ 令牌可以在 FileResolver.Tokens 中找到]
```python
FileResolver.Tokens.mappingPairs
```
## Resolver
We also have the opt-in feature to expose any identifier, regardless of absolute/relative/search path based formatting to be run through our mapped pairs mapping by setting the `AR_EXPOSE_ABSOLUTE_PATH_IDENTIFIERS` environment variable to `1` or by calling `pxr.Ar.GetUnderlyingResolver().SetExposeAbsolutePathIdentifierState(True)`. This then forwards any path to be run through our mapped pairs mapping, regardless of how the identifier is formatted.

[ 我们还可以选择通过设置 AR_FILERESOLVER_ENV_EXPOSE_ABSOLUTE_PATH_IDENTIFIERS 环境变量为 1 或通过调用 pxr.Ar.GetUnderlyingResolver().SetExposeAbsolutePathIdentifierState(True) 来公开任何标识符，无论基于绝对/相对/搜索路径的格式如何]

```python
from pxr import Ar, Usd
from usdAssetResolver import FileResolver

file_resolver = Ar.GetUnderlyingResolver()

# Enable absolute identifier resolving
file_resolver.SetExposeAbsolutePathIdentifierState(True)
print("Resolver is currently exposing absolute path identifiers to the mapping pairs | {}".format(file_resolver.GetExposeAbsolutePathIdentifierState()))
# Or set the "AR_FILERESOLVER_ENV_EXPOSE_ABSOLUTE_PATH_IDENTIFIERS" environment variable to 1.
# This can't be done via Python, as it has to happen before the resolver is loaded.
file_resolver.GetExposeAbsolutePathIdentifierState() # Get the state of exposing absolute path identifiers
file_resolver.SetExposeAbsolutePathIdentifierState() # Set the state of exposing absolute path identifiers
```

## Resolver Context [解析器上下文]
You can manipulate the resolver context (the object that holds the configuration the resolver uses to resolve paths) via Python in the following ways:

[ 您可以用 Python 通过以下方式操作解析器上下文（用于解析路径时使用的配置对象）]

```python
from pxr import Ar, Usd
from usdAssetResolver import FileResolver

# Get via stage
stage = Usd.Stage.Open("/some/stage.usd")
context_collection = stage.GetPathResolverContext()
fileResolver_context = context_collection.Get()[0]
# Or context creation
fileResolver_context = FileResolver.ResolverContext()

# To print a full list of exposed methods:
for attr in dir(FileResolver.ResolverContext):
    print(attr)
```

### Refreshing the Resolver Context [刷新解析器上下文]
```admonish important
If you make changes to the context at runtime, you'll need to refresh it!

[ 如果您在运行时更改上下文，则需要刷新它！]
```
You can reload it as follows, that way the active stage gets the change notification.

[ 您可以按如下方式重新加载它，这样激活的 stage 就会收到更改通知]

```python
from pxr import Ar
resolver = Ar.GetResolver()
context_collection = stage.GetPathResolverContext()
fileResolver_context = context_collection.Get()[0]
# Make edits as described below to the context.
fileResolver_context.AddMappingPair("source.usd", "destination.usd")
# Trigger Refresh (Some DCCs, like Houdini, additionally require node re-cooks.)
resolver.RefreshContext(context_collection)
```

### Search Paths [搜索路径]
The search paths get read from the `AR_SEARCH_PATHS` env var by default. You can inspect and tweak the search paths at runtime by using the following methods:

[ 默认情况下，搜索路径从 AR_SEARCH_PATHS 环境变量中读取. 您可以使用以下方法在运行时检查和调整搜索路]
```python
ctx.GetSearchPaths()                        # Return all search paths (env and custom)
ctx.RefreshSearchPaths()                    # Reload env search paths and re-populates the search paths that the resolver uses. This must be called after changing the env var value or the custom search paths.
ctx.GetEnvSearchPaths()                     # Return all env search paths
ctx.GetCustomSearchPaths()                  # Return all custom search paths
ctx.SetCustomSearchPaths(searchPaths: list) # Set custom search paths
```

### Mapping Pairs [映射键值对]
To inspect/tweak the active mapping pairs, you can use the following:

[ 要检查/调整映射键值对，您可以使用以下命令]
```python
ctx.GetMappingFilePath()                      # Get the mapping file path (Defaults file that the context created Resolver.CreateDefaultContextForAsset() opened)
ctx.SetMappingFilePath(p: str)                # Set the mapping file path
ctx.RefreshFromMappingFilePath()              # Reload mapping pairs from the mapping file path
ctx.GetMappingPairs()                         # Returns all mapping pairs as a dict
ctx.AddMappingPair(src: string, dst: str)     # Add a mapping pair
ctx.ClearMappingPairs()                       # Clear all mapping pairs
ctx.RemoveMappingByKey(src: str)              # Remove a mapping pair by key
ctx.RemoveMappingByValue(dst: str)            # Remove a mapping pair by value
```
To generate a mapping .usd file, you can do the following:

[ 要生成映射 .usd 文件，您可以执行以下操作]
```python
from pxr import Ar, Usd, Vt
from usdAssetResolver import FileResolver
stage = Usd.Stage.CreateNew('/some/path/mappingPairs.usda')
mapping_pairs = {'assets/assetA/assetA.usd':'assets/assetA/assetA_v005.usd', 'shots/shotA/shotA_v000.usd':'shots/shotA/shotA_v003.usd'}
mapping_array = []
for source_path, target_path in mapping_pairs.items():
    mapping_array.extend([source_path, target_path])
stage.SetMetadata('customLayerData', {FileResolver.Tokens.mappingPairs: Vt.StringArray(mapping_array)})
stage.Save()
```

To change the asset path formatting before it is looked up in the mapping pairs, you can do the following:

[ 要在映射键值对中查找资产路径格式之前更改资产路径格式，您可以执行以下操作]

```python
ctx.GetMappingRegexExpression()               # Get the regex expression
ctx.SetMappingRegexExpression(regex_str: str) # Set the regex expression
ctx.GetMappingRegexFormat()                   # Get the regex expression substitution formatting
ctx.SetMappingRegexFormat(f: str)             # Set the regex expression substitution formatting
```