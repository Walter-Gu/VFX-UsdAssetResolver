# Cached Resolver [缓存解析器]
## Overview [概述]
```admonish tip
This resolver first consults an internal resolver context dependent cache to resolve asset paths. If the asset path is not found in the cache, it will redirect the request to Python and cache the result. This is ideal for smaller studios, as this preserves the speed of C++ with the flexibility of Python.

[ 该解析器首先查询内部解析器上下文相关的缓存来解析资源路径. 如果在缓存中没有找到资源路径，则会将请求重定向到Python 并缓存结果. 这对于小型工作室来说是理想的选择，因为它既保留了 C++ 的速度，又保留了 Python 的灵活性]
```

By default (similar to the FileResolver and USD's default resolver), any absolute and relative file path is resolved as an on-disk file path. That means "normal" USD files, that don't use custom identifiers, will resolve as expected (and as fast as usual as this is called in C++).

[ 默认情况下（类似于 FileResolver 和 USD 的默认解析器），任何绝对和相对文件路径都会解析为磁盘上的文件路径. 这意味着不使用自定义标识符的“普通” USD 文件将按预期解析（并且与 C++ 中调用的速度一样快）]

```admonish tip title="Pro Tip"
Optionally you can opt-in into also exposing relative identifiers to Python by setting the `AR_EXPOSE_RELATIVE_PATH_IDENTIFIERS` environment variable to `1` or by calling `pxr.Ar.GetUnderlyingResolver().SetExposeRelativePathIdentifierState(True)`. This is a more advanced feature and is therefore disabled by default. See our [production example](example.md) section for more information on how to use this and why it can be useful.

[ 您还可以选择通过设置 AR_EXPOSE_RELATIVE_PATH_IDENTIFIERS 环境变量 1 或通过调用 pxr.Ar.GetUnderlyingResolver().SetExposeRelativePathIdentifierState(True) 来公开相对标识符. 这是一个更高级的功能，因此默认情况下是禁用的. 有关如何使用此功能以及为什么它可能有用的更多信息，请参阅我们的生产示例部分]

```

All non file path identifiers (anything that doesn't start with "/", "./", "../") will forward their request to the `PythonExpose.py` -> `ResolverContext.ResolveAndCache` method.
If you want to customize this resolver, just edit the methods in PythonExpose.py to fit your needs. You can either edit the file directly or move it anywhere where your "PYTHONPATH"/"sys.path" paths look for Python modules.

[ 所有非文件路径标识符（任何不以“/”、“./”、“../”开头的标识符）都会将其请求转发到 PythonExpose.py -> ResolverContext.ResolveAndCache . 如果您想自定义此解析器，只需编辑 PythonExpose.py 中的方法即可满足您的需求. 您可以直接编辑该文件，也可以将其移动到“PYTHONPATH”/“sys.path”路径查找 Python 模块的任何位置]

```admonish tip title="Pro Tip"
Optionally you can opt-in into also exposing absolute identifiers (so all (absolute/relative/identifiers that don't start with "/","./","../") identifiers) to Python by setting the `AR_EXPOSE_ABSOLUTE_PATH_IDENTIFIERS` environment variable to `1` or by calling `pxr.Ar.GetUnderlyingResolver().SetExposeAbsolutePathIdentifierState(True)`. This enforces all identifiers to run through Python. Use this with care, we recommend only using this for debugging or when having a large dataset of pre-cached mapping pairs easily available.

[ 您还可以选择通过设置 AR_EXPOSE_ABSOLUTE_PATH_IDENTIFIERS 环境变量 1 或通过调用 pxr.Ar.GetUnderlyingResolver().SetExposeAbsolutePathIdentifierState(True) 来公开绝对标识符（因此所有不以“/”、“./”、“../”开头的标识符）. 这会强制所有标识符都通过 Python 运行. 请谨慎使用此功能，我们建议仅在调试或当您有一个易于访问的预缓存映射对数据集时才使用此功能]

```

We also recommend checking out our unit tests of the resolver to see how to interact with it. You can find them in the `<Repo Root>/src/CachedResolver/testenv` folder or on [GitHub](https://github.com/LucaScheller/VFX-UsdAssetResolver/blob/main/src/CachedResolver/testenv/testCachedResolver.py).

[ 我们还建议检查解析器的单元测试，以了解如何与其交互。您可以在“\<Repo Root\>/src/CachedResolver/testenv”文件夹或 [GitHub](https://github.com/LucaScheller/VFX-UsdAssetResolver/blob/main/src/CachedResolver/testenv/testCachedResolver.py) 上找到它们]

Here is a full list of features:

[ 以下是完整的功能列表]
- We support adding caching pairs in two ways, cache-lookup-wise they do the same thing, except the "MappingPairs" have a higher priority than "CachedPairs":

    [ 我们支持两种添加缓存键值对的方式，从缓存查找的角度来看，它们的作用是相同的，但“MappingPairs”的优先级高于“CachedPairs”]
    - **MappingPairs**: All resolver context methods that have `Mapping` in their name, modify the internal `mappingPairs` dictionary. As with the [FileResolver](../FileResolver/overview.md) and [PythonResolver](../PythonResolver/overview.md) resolvers, mapping pairs get populated when creating a new context with a specified mapping file or when editing it via the exposed Python resolver context methods. When loading from a file, the mapping data has to be stored in the Usd layer metadata in an key called ```mappingPairs``` as an array with the syntax ```["sourceIdentifierA.usd", "/absolute/targetPathA.usd", "sourceIdentifierB.usd", "/absolute/targetPathB.usd"]```. (This is quite similar to Rodeo's asset resolver that can be found [here](https://github.com/rodeofx/rdo_replace_resolver) using the AR 1.0 specification.). See our [Python API](./PythonAPI.md) page for more information.

        [ MappingPairs:所有在名称中包含“Mapping”的解析器上下文方法，都会修改内部的 mappingPairs 字典. 与 [FileResolver](../FileResolver/overview.md) 和 [PythonResolver](../PythonResolver/overview.md) 解析器一样，当使用指定的映射文件创建新上下文或通过公开的 Python 解析器上下文方法编辑它时, 会填充映射对. 当从文件中加载时，映射数据必须以数组形式存储在 Usd 层元数据中名为 mappingPairs 的键中，如 ["sourceIdentifierA.usd", "/absolute/targetPathA.usd", "sourceIdentifierB.usd", "/absolute/targetPathB.usd"].（这与 Rodeo 的资源解析器非常相似，可以在 [这里](https://github.com/rodeofx/rdo_replace_resolver) 找到使用 AR 1.0 规范的资源解析器。）有关更多信息，请参阅我们的 [Python API](./PythonAPI.md) 页面]
    - **CachingPairs**: All resolver context methods that have `Caching` in their name, modify the internal `cachingPairs` dictionary. With this dictionary it is up to you when to populate it. In our `PythonExpose.py` file, we offer two ways where you can hook into the resolve process. In both of them you can add as many cached lookups as you want via `ctx.AddCachingPair(asset_path, resolved_asset_path)`:

        [ CachingPairs: 所有在名称中包含“Caching”的解析器上下文方法，都会修改内部的 cachingPairs 字典. 至于何时填充这个字典，完全取决于您. 在我们的 PythonExpose.py 文件中，我们提供了两种您可以介入解析过程的方式. 在这两种方式中，您都可以通过 ctx.AddCachingPair(asset_path, resolved_asset_path) 添加任意数量的缓存查找]
        - On context creation via the `PythonExpose.py` -> `ResolverContext.Initialize` method. This gets called whenever a context gets created (including the fallback default context). For example Houdini creates the default context if you didn't specify a "Resolver Context Asset Path" in your stage on the active node/in the stage network. If you do specify one, then a new context gets spawned that does the above mentioned mapping pair lookup and then runs the `PythonExpose.py` -> `ResolverContext.Initialize` method.

            [ 在通过 PythonExpose.py -> ResolverContext.Initialize 方法创建上下文时，每次创建上下文（包括回退默认上下文）都会调用此方法. 例如，如果你在 stage 的激活节点/ stage network 中没有指定“Resolver Context Asset Path”，Houdini 将创建默认上下文. 如果你明确指定了一个路径，则会创建一个新的上下文，该上下文首先执行上述的映射对查找，然后运行 PythonExpose.py -> ResolverContext.Initialize 方法]
        - On resolve for non file path identifiers (anything that doesn't start with "/"/"./"/"../") via the `PythonExpose.py` -> `ResolverContext.ResolveAndCache` method. Here you are free to only add the active asset path via `ctx.AddCachingPair(asset_path, resolved_asset_path)` or any number of relevant asset paths.
- We optionally also support hooking into relative path identifier creation via Python. This can be enabled by setting the `AR_EXPOSE_RELATIVE_PATH_IDENTIFIERS` environment variable to `1` or by calling `pxr.Ar.GetUnderlyingResolver().SetExposeRelativePathIdentifierState(True)`. We then have access in our `PythonExpose.py` -> `Resolver.CreateRelativePathIdentifier` method. Here we can then return a non file path (anything that doesn't start with "/"/"./"/"../") identifier for our relative path, which then also gets passed to our `PythonExpose.py` -> `ResolverContext.ResolveAndCache` method. This allows us to also redirect relative paths to our liking for example when implementing special pinning/mapping behaviours. For more info check out our [production example](./example.md) section. As with our mapping and caching pairs, the result is cached in C++ to enable faster lookups on consecutive calls. As identifiers are context independent, the cache is stored on the resolver itself. See our [Python API](./PythonAPI.md) section on how to clear the cache.

[ 我们还可选地支持通过 Python 挂钩相对路径标识符创建. 这可以通过将 `AR_EXPOSE_RELATIVE_PATH_IDENTIFIERS` 环境变量设置为 `1` 或调用 `pxr.Ar.GetUnderlyingResolver().SetExposeRelativePathIdentifierState(True)` 来启用. 然后，我们可以在 `PythonExpose.py` -> `Resolver.CreateRelativePathIdentifier` 方法中访问它. 在这里，我们可以返回一个非文件路径（不以 "/"/"./"/"../" 开头的任何路径）标识符，该标识符也会传递给我们的 `PythonExpose.py` -> `ResolverContext.ResolveAndCache` 方法. 这使我们能够根据需要重定向相对路径，例如在实现特殊引脚/映射行为时. 有关更多信息，请查看我们的 [生产示例](./example.md) 部分. 与我们的映射和缓存对一样，结果缓存在 C++ 中，以启用对连续调用的更快查找. 由于标识符是上下文独立的，因此缓存存储在解析器本身. 请参阅我们的 [Python API](./PythonAPI.md) 部分，了解如何清除缓存]

- We optionally also support exposing alle path identifiers to our `ResolverContext.ResolveAndCache` Python method. This can be enabled by setting the `AR_EXPOSE_ABSOLUTE_PATH_IDENTIFIERS` environment variable to `1` or by calling `pxr.Ar.GetUnderlyingResolver().SetExposeAbsolutePathIdentifierState(True)`. This then forwards any path to be run through our Python exposed method, regardless of how the identifier is formatted. Use this with care, we recommend only using this for debugging or when having a large dataset of pre-cached mapping pairs easily available.

[ 我们还可选地支持将所有路径标识符暴露给我们的 `ResolverContext.ResolveAndCache` Python 方法. 这可以通过将 `AR_EXPOSE_ABSOLUTE_PATH_IDENTIFIERS` 环境变量设置为 `1` 或调用 `pxr.Ar.GetUnderlyingResolver().SetExposeAbsolutePathIdentifierState(True)` 来启用. 这会将任何路径转发到我们的 Python 暴露方法中，无论标识符的格式如何. 请谨慎使用此功能，我们建议仅在调试或当您有一个易于访问的大型数据集的预缓存映射对时使用此功能]

- In comparison to our [FileResolver](../FileResolver/overview.md) and [PythonResolver](../PythonResolver/overview.md), the mapping/caching pair values need to point to the absolute disk path (instead of using a search path). We chose to make this behavior different, because in the "PythonExpose.py" you can directly customize the "final" on-disk path to your liking.

[ 与我们的 [FileResolver](../FileResolver/overview.md) 和 [PythonResolver](../PythonResolver/overview.md) 不同，映射/缓存对值需要指向绝对磁盘路径（而不是使用搜索路径）. 我们选择使此行为不同，因为在 "PythonExpose.py" 中，您可以直接自定义最终的磁盘路径以符合您的需求]

- The resolver contexts are cached globally, so that DCCs, that try to spawn a new context based on the same mapping file using the [```Resolver.CreateDefaultContextForAsset```](https://openusd.org/dev/api/class_ar_resolver.html), will re-use the same cached resolver context. The resolver context cache key is currently the mapping file path. This may be subject to change, as a hash might be a good alternative, as it could also cover non file based edits via the exposed Python resolver API.

[ 解析器上下文是全局缓存的，因此当 DCC 工具尝试使用 Resolver.CreateDefaultContextForAsset 基于相同的映射文件创建新的上下文时，会重用相同的缓存解析器上下文. 解析器上下文缓存的键目前是映射文件的路径. 这可能会发生变化，因为哈希可能是一个不错的选择，因为它还可以覆盖通过公开的 Python 解析器 API 进行的非基于文件的编辑]

- ```Resolver.CreateContextFromString```/```Resolver.CreateContextFromStrings``` is not implemented due to many DCCs not making use of it yet. As we expose the ability to edit the context at runtime, this is also often not necessary. If needed please create a request by submitting an issue here: [Create New Issue](https://github.com/LucaScheller/VFX-UsdAssetResolver/issues/new)

    [ Resolver.CreateContextFromString / Resolver.CreateContextFromStrings 尚未实现，因为许多 DCC 尚未使用它. 由于我们公开了在运行时编辑上下文的能力，因此这通常也是不必要的. 如果需要，请通过在此处提交问题来创建请求：[创建新问题](https://github.com/LucaScheller/VFX-UsdAssetResolver/issues/new)]
- Refreshing the stage is also supported, although it might be required to trigger additional reloads in certain DCCs.

    [ 还支持刷新 stage，尽管可能需要在某些 DCC 中触发额外的重新加载]


```admonish warning
While the resolver works and gives us the benefits of Python and C++, we don't guarantee its scalability. If you look into our source code, you'll also see that our Python invoke call actually circumvents the "const" constant variable/pointers in our C++ code. USD API-wise the resolve ._Resolve calls should only access a read-only context. We side-step this design by modifying the context in Python. Be aware that this could have side effects.

[ 虽然解析器能够正常工作，并为我们带来了 Python 和 C++ 的优点，但我们并不保证它的可扩展性. 如果你查看我们的源代码，你会发现我们的 Python 调用实际上绕过了 C++ 代码中的“const”常量变量/指针. 就 USD API 而言，resolve._Resolve 调用应该只访问只读上下文. 我们通过在 Python 中修改上下文来绕过这种设计.请注意，这可能会产生副作用]
```

## Debug Codes [调试代码]
Adding following tokens to the `TF_DEBUG` env variable will log resolver information about resolution/the context respectively.

[   将以下标记添加到 TF_DEBUG 环境变量将分别记录有关解析和上下文的解析器信息]
* `CACHEDRESOLVER_RESOLVER`
* `CACHEDRESOLVER_RESOLVER_CONTEXT`

For example to enable it on Linux run the following before executing your program:

[ 例如，要在 Linux 上启用它，请在执行程序之前运行以下命令]

```bash
export TF_DEBUG=CACHEDRESOLVER_RESOLVER_CONTEXT
```