# Automatic/Quick Installation [自动/快速安装]

```admonish tip
We offer a quick install method that does the download of the compiled resolvers and environment variable setup for you. This is ideal if you want to get your hands dirty right away and you don't have any C++ knowledge or extensive USD developer knowledge. If you are a small studio, you can jump right in and play around with our resolvers and prototype them further to make it fit your production needs.

[ 我们提供了一个快速安装方法，可以为您下载已编译的解析器并设置环境变量. 如果您想立即开始操作且没有 C++ 知识或大量的USD开发经验，那么这将是一个理想的选择. 如果您是一个小型工作室，您可以立即加入进来，尝试使用我们的解析器，并进一步原型设计以满足您的生产需求]
```

Currently we only support doing this in Houdini and Maya.

[ 目前我们仅支持在 Houdini 和 Maya 中执行此操作]

## Update Manager [更新管理器]
Installing is done via the "USD Asset Resolver - Update Manager". Depending on the application, running the installer is a bit different, for more information check the specific app instructions below.

[ 安装是通过“USD Asset Resolver - Update Manager”完成的. 根据应用程序的不同，运行安装程序略有不同，有关更多信息，请查看下面的特定应用程序说明]

![Update Manager](./media/UpdateManager.jpg)

The update dialog will prompt you for an installation directory and offers you to choose between different releases and resolvers.
Once you have made your choices, you can press install and the chosen resolver will be installed.

[ 更新对话框将提示您输入安装目录，并让您在不同的版本和解析器之间进行选择. 做出选择后，您可以按"Install"，然后将安装所选的解析器]

As mentioned in our [Resolvers Plugin Configuration](../resolvers/overview.md#usd-plugin-configuration) section, we need to setup a few environment variables before launching our application so that USD detects our resolver.

[ 正如我们的 [解析器插件配置](../resolvers/overview.md#usd-plugin-configuration) 部分中提到的，我们需要在启动应用程序之前设置一些环境变量，以便 USD 检测到我们的解析器]

In your install directory you will find a "launch.sh/.bat" file, which does this for you based on what host app you ran the installer in.
All you then have to do is run the "launch.sh/.bat" file by double clicking it and then your app should open as usual with the resolver running. In the launch file we have enabled the "TF_DEBUG=AR_RESOLVER_INIT" environment variable, so there will be debug logs where you can see if everything worked correctly.

[ 在您的安装目录中，您将找到一个“launch.sh/.bat”文件，它会根据您运行安装程序的主机应用程序来为您执行上述操作. 然后，您只需双击“launch.sh/.bat”文件运行它，您的应用程序应该会像往常一样打开并运行解析器. 在启动文件中，我们启用了“TF_DEBUG=AR_RESOLVER_INIT”环境变量，因此将会有调试日志，您可以在其中查看一切是否正常工作]

![Install folder and launcher](./media/AutomaticInstallFolder.png)

## Houdini
In Houdini we simply need to open the "Python Source Editor" from the "Windows" menu and run the following code to get access to the update manager. You should preferably do this in a clean Houdini session as a safety measure.

[ 在Houdini中，我们只需从“Windows”菜单中打开"Python Source Edito”并运行以下代码即可访问更新管理器. 作为安全措施，您最好在干净的 Houdini 会话中执行此操作]

~~~admonish info title=""
```python
import ssl; from urllib import request
update_manager_url = 'https://raw.githubusercontent.com/LucaScheller/VFX-UsdAssetResolver/main/tools/update_manager.py?token=$(date+%s)'
exec(request.urlopen(update_manager_url,context=ssl._create_unverified_context()).read(), globals(), locals())
run_dcc()
```
~~~

![Houdini Python Source editor](./media/HoudiniPythonSourceEditor.jpg)

We also recommend turning "Set Asset Resolver Context From LOP Node Parameters" off, if you want to drive the context via the /stage preferences.
Leaving it on will require you to use a "Configure Stage" LOP  node.

![Houdini Asset Resolver Context Preferences editor](./media/HoudiniAssetResolverContextPreferences.jpg)

## Maya
In Maya we simply need to open the "Script Editor" and run the following code to get access to the update manager. You should preferably do this in a clean Maya session as a safety measure.

[ 在 Maya 中，我们只需打开“Script Editor”并运行以下代码即可访问更新管理器. 作为安全措施，您最好在干净的 Maya 会话中执行此操作]

~~~admonish info title=""
```python
import ssl; from urllib import request
update_manager_url = 'https://raw.githubusercontent.com/LucaScheller/VFX-UsdAssetResolver/main/tools/update_manager.py?token=$(date+%s)'
exec(request.urlopen(update_manager_url,context=ssl._create_unverified_context()).read(), globals(), locals())
run_dcc()
```
~~~
