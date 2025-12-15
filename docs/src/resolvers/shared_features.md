#// ANCHOR: resolverOverview
- **Production Resolvers [ 生产可用的解析器]**
    - **File Resolver** - A file system based resolver similar to the default resolver with support for custom mapping pairs as well as at runtime modification and refreshing.

        [ File Resolver: 基于文件系统的解析器，类似于默认解析器，支持自定义映射键值对以及运行时修改和刷新]
    - **Cached Resolver** - A resolver that first consults an internal resolver context dependent cache to resolve asset paths. If the asset path is not found in the cache, it will redirect the request to Python and cache the result. This is ideal for smaller studios, as this preserves the speed of C++ with the flexibility of Python.

        [ Cached Resolver: 它首先通过查询内部解析器上下文的缓存来解析资产路径.如果资产路径在缓存中找不到，它会将请求重定向到 Python 并缓存结果. 这对于小型工作室来说非常理想，因为它既保留了 C++ 的速度，又具备Python 的灵活性]
- **RnD Resolvers [研发 解析器]**
    - **Python Resolver** - Python based implementation of the file resolver. The goal of this resolver is to enable easier RnD by running all resolver and resolver context related methods in Python. It can be used to quickly inspect resolve calls and to setup prototypes of resolvers that can then later be re-written in C++ as it is easier to code database interactions in Python for initial research.

        [ Python Resolver: 基于Python的文件解析器实现. 该解析器的目标是通过在 Python 中运行所有与解析器和解析器上下文相关的方法，来使研发变得更加容易. 它可用于快速检查解析调用，并设置解析器的原型，随后可以用 C++ 重写这些原型，因为对于初步研究来说，在 Python 中编写数据库交互代码更为简单]
- **Proof Of Concept Resolvers [概念性 解析器]**
    - **Http Resolver** - A proof of concept http resolver. This is kindly provided and maintained by @charlesfleche in the [arHttp: Offloads USD asset resolution to an HTTP server
    ](https://github.com/charlesfleche/arHttp) repository. For documentation, feature suggestions and bug reports, please file a ticket there. This repo handles the auto-compilation against DCCs and exposing to the automatic installation update manager UI.

        [ Http Resolver: 一个概念性的HTTP解析器.这个解析器由@charlesfleche维护在  [arHttp: Offloads USD asset resolution to an HTTP server](https://github.com/charlesfleche/arHttp).有关文档、功能建议和错误报告，请在那里提交工单. 此存储库处理针对 DCC 的自动编译并公开给自动安装更新管理器 UI]

#// ANCHOR_END: resolverOverview

#// ANCHOR: resolverSharedFeatures
- A simple mapping pair look up in a provided mapping pair Usd file. The mapping data has to be stored in the Usd layer metadata in an key called ```mappingPairs``` as an array with the syntax ```["sourcePathA.usd", "targetPathA.usd", "sourcePathB.usd", "targetPathB.usd"]```. (This is quite similar to Rodeo's asset resolver that can be found [here](https://github.com/rodeofx/rdo_replace_resolver) using the AR 1.0 specification.)

    [ 在提供的映射键值对 USD 文件中进行简单的映射查找. 映射数据必须以数组形式存储在 Usd 层元数据中名为 `mappingPairs` 的键中，其语法为`["sourcePathA.usd", "targetPathA.usd", "sourcePathB.usd", "targetPathB.usd"]`.（这与Rodeo的资产解析器非常相似，该解析器可以在[这里](https://github.com/rodeofx/rdo_replace_resolver)使用AR 1.0规范找到）]
- The search path environment variable by default is ```AR_SEARCH_PATHS```. It can be customized in the [CMakeLists.txt](https://github.com/LucaScheller/VFX-UsdAssetResolver/blob/main/CMakeLists.txt) file.

    [ 搜索路径的环境变量默认是 AR_SEARCH_PATHS. 可以在 [CMakeLists.txt](https://github.com/LucaScheller/VFX-UsdAssetResolver/blob/main/CMakeLists.txt) 文件中进行自定义]
- You can use the ```AR_ENV_SEARCH_REGEX_EXPRESSION```/```AR_ENV_SEARCH_REGEX_FORMAT``` environment variables to preformat any asset paths before they looked up in the ```mappingPairs```. The regex match found by the ```AR_ENV_SEARCH_REGEX_EXPRESSION``` environment variable will be replaced by the content of the  ```AR_ENV_SEARCH_REGEX_FORMAT``` environment variable. The environment variable names can be customized in the [CMakeLists.txt](https://github.com/LucaScheller/VFX-UsdAssetResolver/blob/main/CMakeLists.txt) file.

    [ 您可以使用 `AR_ENV_SEARCH_REGEX_EXPRESSION` / `AR_ENV_SEARCH_REGEX_FORMAT` 环境变量在 `mappingPairs` 中查找任何资源路径之前对其进行预格式化. `AR_ENV_SEARCH_REGEX_EXPRESSION` 环境变量找到的正则表达式匹配将替换为 AR_ENV_SEARCH_REGEX_FORMAT 环境变量的内容. 这些环境变量的名称可以在 [CMakeLists.txt](https://github.com/LucaScheller/VFX-UsdAssetResolver/blob/main/CMakeLists.txt) 文件中进行自定义]
- The resolver contexts are cached globally, so that DCCs, that try to spawn a new context based on the same mapping file using the [```Resolver.CreateDefaultContextForAsset```](https://openusd.org/dev/api/class_ar_resolver.html), will re-use the same cached resolver context. The resolver context cache key is currently the mapping file path. This may be subject to change, as a hash might be a good alternative, as it could also cover non file based edits via the exposed Python resolver API.

    [ 解析器上下文是全局缓存的，因此，当 DCC 软件尝试使用 [```Resolver.CreateDefaultContextForAsset```](https://openusd.org/dev/api/class_ar_resolver.html) 基于相同的映射文件创建新的上下文时，会重用相同的缓存解析器上下文. 解析器上下文缓存键当前是映射文件的路径. 这可能会发生变化，因为哈希可能是一个不错的选择，因为它也可以通过公开的 Python 解析器 API 覆盖非基于文件的编辑]
- ```Resolver.CreateContextFromString```/```Resolver.CreateContextFromStrings``` is not implemented due to many DCCs not making use of it yet. As we expose the ability to edit the context at runtime, this is also often not necessary. If needed please create a request by submitting an issue here: [Create New Issue](https://github.com/LucaScheller/VFX-UsdAssetResolver/issues/new)

    [ 由于许多 DCC 软件尚未使用 `Resolver.CreateContextFromString/Resolver.CreateContextFromStrings`，因此尚未实现这些功能. 由于我们公开了在运行时编辑上下文的能力，因此这通常也是不必要的. 如有需要，请通过在此处提交问题来创建请求：[创建新问题](https://github.com/LucaScheller/VFX-UsdAssetResolver/issues/new)
]
#// ANCHOR_END: resolverSharedFeatures

#// ANCHOR: resolverEnvConfiguration
## Resolver Environment Configuration [解析器环节变量配置]
- `AR_SEARCH_PATHS`: The search path for non absolute asset paths.

    [ AR_SEARCH_PATHS: 非绝对路径资源的搜索路径]
- `AR_SEARCH_REGEX_EXPRESSION`: The regex to preformat asset paths before mapping them via the mapping pairs.

    [ AR_SEARCH_REGEX_EXPRESSION: 这个正则表达式用于在通过映射键值对进行映射之前对资源路径进行预格式化]
- `AR_SEARCH_REGEX_FORMAT`: The string to replace with what was found by the regex expression.

    [ AR_SEARCH_REGEX_FORMAT: 这个字符串将替换正则表达式所找到的内容]

The resolver uses these env vars to resolve non absolute asset paths relative to the directories specified by `AR_SEARCH_PATHS`. For example the following substitutes any occurrence of `v<3digits>` with `v000` and then looks up that asset path in the mapping pairs.

[ 解析器使用这些环境变量来解决非绝对路径资源，这些路径相对于由 `AR_SEARCH_PATHS` 指定的目录. 例如，以下操作会将任何 `v<3digits>` 的出现替换为 `v000`，然后在映射对中查找该资源路径]

~~~admonish info title=""
```bash
export AR_SEARCH_PATHS="/workspace/shots:/workspace/assets"
export AR_SEARCH_REGEX_EXPRESSION="(v\d\d\d)"
export AR_SEARCH_REGEX_FORMAT="v000"
```
~~~
#// ANCHOR_END: resolverEnvConfiguration