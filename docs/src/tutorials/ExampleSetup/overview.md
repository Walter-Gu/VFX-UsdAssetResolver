# Example Usd files and mapping pair files

```admonish warning
These examples currently work with the [File Resolver](../FileResolver/overview.md) and [Python Resolver](../PythonResolver/overview.md).

[ 这些示例当前适用于 [文件解析器](../FileResolver/overview.md) 和 [Python 解析器](../PythonResolver/overview.md)]

For resolver specific examples, see the corresponding resolver section.

[ 有关解析器特定示例，请参阅相应的解析器部分]
```

## Simple Example

A very simple setup can be found in In the <REPO_ROOT>/files folder.

[ 可以在 \<REPO_ROOT\>/files 文件夹中找到非常简单的设置]

Before launching a Usd related software, you'll have to set these env vars:

[ 在启动 USD 相关软件之前，您必须设置这些环境变量]
```bash
export AR_SEARCH_PATHS=${REPO_ROOT}/files/generic
export AR_SEARCH_REGEX_EXPRESSION="(bo)"
export AR_SEARCH_REGEX_FORMAT="Bo"
```
The `source setup.sh` bash script in the root of this repo also does this for your automatically.
After that load the `box.usda` in the application of your choice. Make sure to load `box.usda`and not `/path/to/repo/box.usda` as the resolver only resolves paths that use the search path mechanism.
You should now see a cube. If you set the resolver context to the `mapping.usda` file, it will be replaced to a cylinder.

[ 此存储库根目录中的 source setup.sh bash 脚本也会自动为您执行此操作. 之后在您选择的应用程序中加载 `box.usda` 确保加载 `box.usda` 而不是 `/path/to/repo/box.usda` 因为解析器仅解析使用搜索路径机制的路径. 您现在应该看到一个立方体, 如果将解析器上下文设置为 `mapping.usda` 文件，它将被替换为圆柱体]

## Production Example

A larger example scene setup might looks as follows:

[ 更大的示例场景设置可能如下所示]
- The following files on disk:

    [ 磁盘上有以下文件]
    - `/workspace/shots/shotA/shotA.usd`
    - `/workspace/shots/shotA/shotA_mapping.usd`
    - `/workspace/assets/assetA/assetA.usd`
    - `/workspace/assets/assetA/assetA_v001.usd`
    - `/workspace/assets/assetA/assetA_v002.usd`
- The ```AR_SEARCH_PATHS``` environment variable being set to `/workspace/shots:/workspace/assets`

    [ AR_SEARCH_PATHS 环境变量设置为 `/workspace/shots:/workspace/assets`]

In the <REPO_ROOT>/files folder you can also find this setup. To run it, you must set the `AR_SEARCH_PATHS` env var as follows.

[ 在 \<REPO_ROOT\>/files 文件夹中您还可以找到此设置. 要运行它，您必须按如下方式设置 `AR_SEARCH_PATHS` 环境变量]
```bash
export AR_SEARCH_PATHS=${REPO_ROOT}/files/generic/workspace/shots:${REPO_ROOT}/files/generic/workspace/assets
```
And then open up the `shots/shotA/shotA.usd` file and set the resolver context mapping file path to `shots/shotA/shotA_mapping.usd`. 

[ 然后打开 `shots/shotA/shotA.usd` 文件并将解析器上下文映射文件路径设置为 `shots/shotA/shotA_mapping.usd`]

In Houdini this is done by loading the shot file via a sublayer node and setting the `Resolver Context Asset Path` parm to the mapping file path in the [`Scene Graph Tree`>`Opens the parameter dialog for the current LOP Network`](https://www.sidefx.com/docs/houdini/ref/panes/scenegraphtree.html) button.

[ 在 Houdini 中这是通过子层节点加载镜头文件并将 `Resolver Context Asset Path` 参数设置为 [`Scene Graph Tree`>`Opens the parameter dialog for the current LOP Network`](https://www.sidefx.com/docs/houdini/ref/panes/scenegraphtree.html) 按钮中的映射文件路径来完成的]

You'll see the box being replaced to cylinder.

[ 您会看到盒子被替换为圆柱体]

### Content structure

Content of a USD file located at `/workspace/shots/shotA/shotA.usd`
```python
#usda 1.0
def "testAssetA" (
    prepend references = @assetA/assetA.usd@</asset>
)
{
}
```
Content of the USD file located at `/workspace/shots/shotA/shotA_mapping.usd`

```python
#usda 1.0
(
    customLayerData = {
        string[] mappingPairs = ["assetA/assetA.usd", "assetA/assetA_v002.usd"]
    }
)
```

Content of the USD files located at `/workspace/assets/assetA/assetA.usd` and `/workspace/assets/assetA/assetA_v001.usd`
```python
#usda 1.0
def Cube "asset" ()
{
    double size = 2
}
```
Content of the USD file located at `/workspace/assets/assetA/assetA.usd` and `/workspace/assets/assetA/assetA_v002.usd`
```python
#usda 1.0
def Cylinder "asset" ()
{
}
```