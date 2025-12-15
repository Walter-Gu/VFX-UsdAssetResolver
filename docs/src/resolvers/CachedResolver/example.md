# Production Setup

In this example we examine how a possible production setup would look like.

[ 在此示例中，我们研究了可能的生产设置是什么样子的]

We enable the advanced feature of exposing relative identifiers to Python by setting the `AR_EXPOSE_RELATIVE_PATH_IDENTIFIERS` environment variable to `1`.

[ 我们通过将 AR_EXPOSE_RELATIVE_PATH_IDENTIFIERS 环境变量设置为 1 来启用向 Python 公开相对标识符的高级功能]

## Prerequisites [先决条件]

To run the example, we must first initialize our environment.

[ 要运行该示例，我们必须首先初始化我们的环境]

If you are using the pre-compiled builds, make sure that you adjust the paths accordingly.

[ 如果您使用预编译的版本，请确保相应地调整路径]

~~~admonish info title=""
```bash
# Linux
export PYTHONPATH=${REPO_ROOT}/files/implementations/CachedResolver/code:${REPO_ROOT}/dist/${RESOLVER_NAME}/lib/python:${PYTHONPATH}
export PXR_PLUGINPATH_NAME=${REPO_ROOT}/dist/${RESOLVER_NAME}/resources:${PXR_PLUGINPATH_NAME}
export LD_LIBRARY_PATH=${REPO_ROOT}/dist/${RESOLVER_NAME}/lib
export AR_EXPOSE_RELATIVE_PATH_IDENTIFIERS=1
# Windows
set PYTHONPATH=%REPO_ROOT%\files\implementations\CachedResolver\code;%REPO_ROOT%\dist\%RESOLVER_NAME%\lib\python;%PYTHONPATH%
set PXR_PLUGINPATH_NAME=%REPO_ROOT%\dist\%RESOLVER_NAME%\resources;%PXR_PLUGINPATH_NAME%
set PATH=%REPO_ROOT%\dist\%RESOLVER_NAME%\lib;%PATH%
set AR_EXPOSE_RELATIVE_PATH_IDENTIFIERS=1
```
~~~

You'll also need to adjust the `shotA_mapping.usd` to point to absolute file paths:

[ 您还需要调整 shotA_mapping.usd 以指向绝对文件路径]

```python
#usda 1.0
(
    customLayerData = {
        string[] mappingPairs = [
            "assets/assetA", "<Change/This/Path/To/Be/Absolute>/files/implementations/CachedResolver/workspace/assets/assetA/assetA_v002.usd",
            "relativeIdentifier|assets/assetA?surface", "<Change/This/Path/To/Be/Absolute>/files/implementations/CachedResolver/workspace/assets/assetA/elements/surface_v001.usd"
        ]
    }
)
```

## Demo [演示]
Let's have a look how we can demo this setup in Houdini.

[ 让我们看看如何在 Houdini 中演示此设置]


### Loading our Shot
If everything was initialized correctly, we can sublayer in the shot A USD file by referring to it via `shots/shotA`

[ 如果一切都正确初始化，我们可以通过 shots/shotsA 引用 shot A USD 文件来对其进行子分层]

![Houdini Shot](./media/ProductionExampleHoudiniShot.png)

Let's inspect what is happening in our `PythonExpose.py`` file:

[ 让我们检查一下“PythonExpose.py”文件中发生了什么]

```python
...
class ResolverContext:

    @staticmethod
    @log_function_args
    def ResolveAndCache(context, assetPath):
        """Return the resolved path for the given assetPath or an empty
        ...
        """
        ...
        resolved_asset_path = ""
        if assetPath.startswith(RELATIVE_PATH_IDENTIFIER_PREFIX):
            ...
        else:
            ####### DOCS
            """ Since our asset identifier doesn't start with our relative path prefix (more on that below),
            the resolve code here is executed. Here we simply map our entity (asset/shot)
            to a specific version, usually the latest one. You'd replace this with a
            database call or something similar. You can also batch call .AddCachingPair
            for multiple paths here (or preferably in the ResolverContext.Initialize method).
            """
            #######
            entity_type, entity_identifier = assetPath.split("/")
            # Here you would add your custom "latest version" query.
            resolved_asset_path = os.path.join(ENTITY_TYPE_TO_DIR_PATH[entity_type],
                                               entity_identifier,
                                               f"{entity_identifier}_v002.usd")
        # Cache result
        context.AddCachingPair(assetPath, resolved_asset_path)
        return resolved_asset_path
...
```

So far so good? Alright, then let's look at some pinning examples.

[ 到目前为止，一切都很好？好吧，那么让我们看一些固定示例]

Different pipelines use different mechanisms of loading specific versions. These two ways are the most common ones:

[ 不同的流程使用不同的机制来加载特定版本. 这两种方式是最常见的]
- Opt-In: A user has to manually opt-in to loading specific/the latest versions

    [ Opt-In：用户必须手动选择加载特定/最新版本]
- Opt-Out: The user always gets the latest version, but can optionally opt-out and pin/map specific versions that should not change.

    [ Opt-Out：用户始终获得最新版本，但可以选择选择退出并固定/映射不应更改的特定版本]

With both methods, we need a pinning mechanism (as well as when we typically submit to a render farm as nothing should change there).

    [ 对于这两种方法，我们都需要一个固定机制（以及当我们通常提交到渲染农场时，因为那里不应发生任何变化）]

We provide this by either live modifying the context (see the [Python API](./PythonAPI.md) section) or by providing a pinning file.

    [ 我们通过实时修改上下文（请参阅 Python API 部分）或提供固定文件来提供此功能]

### Loading Pinning
We can load our pinning via a configure stage node or via the lop network settings, more info on that can be found in the [USD Survival Guide - Asset Resolver](https://lucascheller.github.io/VFX-UsdSurvivalGuide/dcc/houdini/approach.html#compositionAssetResolver) section.

[ 我们可以通过 "configure stage"节点或通过 "lop network" 设置加载固定，更多信息可以在[USD Survival Guide - Asset Resolver](https://lucascheller.github.io/VFX-UsdSurvivalGuide/dcc/houdini/approach.html#compositionAssetResolver)部分找到]

![Houdini Shot Pinning](./media/ProductionExampleHoudiniShotPinning.png)

Let's have a look at the content of our pinning file.

[ 让我们看一下固定文件的内容]

```python
#usda 1.0
(
    customLayerData = {
        string[] mappingPairs = [
            "assets/assetA", "<Change/This/Path/To/Be/Absolute>/files/implementations/CachedResolver/workspace/assets/assetA/assetA_v002.usd",
            "relativeIdentifier|assets/assetA?surface", "<Change/This/Path/To/Be/Absolute>/files/implementations/CachedResolver/workspace/assets/assetA/elements/surface_v001.usd"
        ]
    }
)
```

Here we decided to pin/map two things:

[ 在这里，我们决定固定/映射两件事]
- An asset
- An element of an asset

In a production scenario you would pin everything when submitting to the render farm/when saving a scene to keep the state of the scene re-constructable. We decided to not do this here, to showcase the more complicated case of mapping only specific relative paths.

[ 在生产场景中，您将在提交到渲染场/保存场景时固定所有内容，以保持场景状态可重构. 我们决定不在这里这样做，以展示仅映射特定相对路径的更复杂的情况]

In this case the result is that the v002 of our assetA is being loaded, but with v001 of our surface version and v002 of our model version. Where does the version v002 for our model come from?

[ 在这种情况下，结果是我们的 assetA 的 v002 正在加载，但带有我们的 Surface 版本的 v001 和我们的模型版本的 v002. 我们模型的 v002 版本从哪里来？]


When opt-in-ing to expose relative identifiers to Python, the method below gets called.

[ 当选择向 Python 公开相对标识符时，将调用以下方法]

```python
...
class Resolver:

    @staticmethod
    @log_function_args
    def CreateRelativePathIdentifier(resolver, anchoredAssetPath, assetPath, anchorAssetPath):
        """Returns an identifier for the asset specified by assetPath and anchor asset path.
        ...
        """
        LOG.debug("::: Resolver.CreateRelativePathIdentifier | {} | {} | {}".format(anchoredAssetPath, assetPath, anchorAssetPath))
        # For this example, we assume all identifier are anchored to the shot and asset directories.
        # We remove the version from the identifier, so that our mapping files can target a version-less identifier.
        anchor_path = anchorAssetPath.GetPathString()
        anchor_path = anchor_path[:-1] if anchor_path[-1] == os.path.sep else anchor_path[:anchor_path.rfind(os.path.sep)]
        entity_type = os.path.basename(os.path.dirname(anchor_path))
        entity_identifier = os.path.basename(anchor_path)
        entity_element = os.path.basename(assetPath).split("_")[0]

        remapped_relative_path_identifier = f"{RELATIVE_PATH_IDENTIFIER_PREFIX}{entity_type}/{entity_identifier}?{entity_element}"
        resolver.AddCachedRelativePathIdentifierPair(anchoredAssetPath, remapped_relative_path_identifier)

        # If you don't want this identifier to be passed through to ResolverContext.ResolveAndCache
        # or the mapping/caching mechanism, return this:
        # resolver.AddCachedRelativePathIdentifierPair(anchoredAssetPath, anchoredAssetPath)
        # return anchoredAssetPath

        return remapped_relative_path_identifier
...
```

~~~admonish tip title="Pro Tip"
As you may have noticed our remapped identifier still contains the version, while in our mapping file it doesn't!
Why do we encode it here? Because it allows us to keep the "default" relative path expansion behaviour intact whilst having the option to override it in our ResolverContext.ResolveAndCache method.
That way writing the mapping is easier and the applied mapping is cached and fast after the first .ResolveAndCache run of each versioned relative identifier.

[ 您可能已经注意到，我们重新映射的标识符仍然包含版本，而在我们的映射文件中则不包含版本！为什么我们要在这里编码？因为它允许我们保持“默认”相对路径扩展行为完整，同时可以选择在 ResolverContext.ResolveAndCache 方法中覆盖它. 这样，编写映射会更容易，并且在每个版本化相对标识符的第一次 .ResolveAndCache 运行之后，所应用的映射会被缓存并且速度很快]

Another question your might ask is why don't we encode it as a "normal" identifier from the start? That is a very valid solution too! By making it relative we optionally have a way to disconnect versions. This allows us to opt-in to this behaviour instead of having to always have a resolver query the correct file for us. This allows us to view files with relative paths even without a custom file resolver!

[ 您可能会问的另一个问题是我们为什么不从一开始就将其编码为“通用”标识符？这也是一个非常有效的解决方案！通过使其相对，我们可以选择有一种方法来断开版本连接. 这允许我们选择这种行为，而不必总是让解析器为我们查询正确的文件. 这使我们即使没有自定义文件解析器也可以查看具有相对路径的文件！]
~~~

In our resolver we then map all relative file path identifiers to their originally intended paths, either by using our mapping or by using our "fallback"/original encoded version.
(As a side note in case you forgot: Only identifiers that do not have a match in our mapping pair dict get piped through to ResolveAndCache method. So in this case our asset element model and surface files.)

[ 然后，在我们的解析器中，我们通过使用映射或使用我们的“后备”/原始编码版本，将所有相对文件路径标识符映射到其最初的预期路径. （作为旁注，以防您忘记：只有在我们的映射对字典中不匹配的标识符才会通过流程传输到 ResolveAndCache 方法. 因此在本例中是我们的资产元素模型和表面文件）]

```python
...
class ResolverContext:

    @staticmethod
    @log_function_args
    def ResolveAndCache(context, assetPath):
        """Return the resolved path for the given assetPath or an empty
        ...
        """
        ...
        resolved_asset_path = ""
        if assetPath.startswith(RELATIVE_PATH_IDENTIFIER_PREFIX):
            ####### DOCS
            """The v002 version of our model .usd file and v001 of our surface model .usd file come from our resolve cache method.
            For our model file, we extract the version from our identifier, for our surface file we use our mapping pairs.
            The later means that we first have a mapping pair cache hit miss (in the C++ resolver code) and therefore ResolveAndCache gets called, which then
            re-applies the correct mapping. If the identifier is encountered again it will use the C++ cache, which means everything is kept fast.
            """
            #######
            base_identifier = assetPath[len(RELATIVE_PATH_IDENTIFIER_PREFIX):]
            anchor_path, entity_element = base_identifier.split("?")
            entity_type, entity_identifier = anchor_path.split("/")
            entity_element, entity_version = entity_element.split("_")
            # Here you would add your custom relative path resolve logic.
            # We can test our mapping pairs to see if the version is pinned, otherwise we fallback to the original intent.
            versionless_identifier = f"{RELATIVE_PATH_IDENTIFIER_PREFIX}{entity_type}/{entity_identifier}?{entity_element}"
            mapping_pairs = context.GetMappingPairs()
            mapping_hit = mapping_pairs.get(versionless_identifier)
            if mapping_hit:
                resolved_asset_path = mapping_hit
            else:
                resolved_asset_path = os.path.normpath(os.path.join(ENTITY_TYPE_TO_DIR_PATH[entity_type],
                                                                    entity_identifier,
                                                                    "elements", f"{entity_element}_{entity_version}.usd"))
        else:
            ...
        # Cache result
        context.AddCachingPair(assetPath, resolved_asset_path)
        return resolved_asset_path
...
```

### Summary [总结]
And that's all folks! We encourage you to also play around with the code or adjusting the mapping files to see how everything works.

[ 各位，以上就是全部内容了！我们鼓励您尝试修改代码或调整映射文件，以查看它们是如何工作的]

If you make live adjustments via the API, don't forget to refresh the context as described in our [Python API](./PythonAPI.md#refreshing-the-resolver-context) section.
[ 如果您通过 API 进行实时调整，请不要忘记刷新上下文，如我们的 Python API 部分中所述]


## Content Structure
To make the example setup a bit simpler, our shot setup does not contain any shot layers. In a real production setup it would be setup similar to our assets.

[ 为了使示例设置更简单，我们的镜头设置不包含任何镜头层. 在实际的生产设置中，它的设置类似于我们的资产]

### Shots
Content of a USD file located at `/workspace/shots/shotA/shot_v002.usd`
```python
#usda 1.0
def Xform "testAssetA_1" (
    prepend references = @assets/assetA@</asset>
)
{
}

def Xform "testAssetA_2" (
    prepend references = @assets/assetA@</asset>
)
{
    matrix4d xformOp:transform:transform1 = ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 10, 0, 1) )
    uniform token[] xformOpOrder = ["xformOp:transform:transform1"]
}
```

Content of a USD file located at `/workspace/shots/shotA/shot_v001.usd`
```python
#usda 1.0
def Xform "testAssetA_1" (
    prepend references = @assets/assetA@</asset>
)
{
}

def Xform "testAssetA_2" (
    prepend references = @assets/assetA@</asset>
)
{
    matrix4d xformOp:transform:transform1 = ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 3, 0, 1) )
    uniform token[] xformOpOrder = ["xformOp:transform:transform1"]
}
```

### Assets
Content of a USD file located at `/workspace/assets/assetA/assetA_v002.usd`
```python
#usda 1.0
def Xform "asset" (
    prepend references = [@./elements/model_v002.usd@</asset>, @./elements/surface_v002.usd@</asset>]
)
{
}
```

Content of a USD file located at `/workspace/assets/assetA/assetA_v001.usd`
```python
#usda 1.0
def Xform "asset" (
    prepend references = [@./elements/model_v001.usd@</asset>, @./elements/surface_v001.usd@</asset>]
)
{
}
```

### Asset Elements
#### Model
Content of a USD file located at `/workspace/assets/assetA/elements/model_v001.usd`
```python
#usda 1.0
def "asset" ()
{
    def Cube "shape" ()
    {
        double size = 2
    }
}
```

Content of a USD file located at `/workspace/assets/assetA/elements/model_v002.usd`
```python
#usda 1.0
def "asset" ()
{
    def Cylinder "shape" ()
    {
    }
}
```
#### Surface
Content of a USD file located at `/workspace/assets/assetA/elements/surface_v001.usd`
```python
#usda 1.0
def "asset" ()
{
    color3f[] primvars:displayColor = [(1, 0, 0)] (
        interpolation = "constant"
    )
}
```

Content of a USD file located at `/workspace/assets/assetA/elements/surface_v002.usd`
```python
#usda 1.0
def "asset" ()
{
    color3f[] primvars:displayColor = [(0, 1, 0)] (
        interpolation = "constant"
    )
}
```