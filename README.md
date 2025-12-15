| <img src="https://raw.githubusercontent.com/LucaScheller/VFX-UsdAssetResolver/main/tools/UsdAssetResolver_Logo.svg" width="128"> |  <h1> OpenUSD Asset Resolver </h1> |
|--|--|

[![Deploy Documentation to GitHub Pages](https://github.com/LucaScheller/VFX-UsdAssetResolver/actions/workflows/mdbook.yml/badge.svg)](https://github.com/LucaScheller/VFX-UsdAssetResolver/actions/workflows/mdbook.yml)
[![Build USD Asset Resolvers against USD](https://github.com/LucaScheller/VFX-UsdAssetResolver/actions/workflows/build_standalone.yml/badge.svg)](https://github.com/LucaScheller/VFX-UsdAssetResolver/actions/workflows/build_standalone.yml)
[![Build USD Asset Resolvers against Houdini](https://github.com/LucaScheller/VFX-UsdAssetResolver/actions/workflows/build_houdini.yml/badge.svg)](https://github.com/LucaScheller/VFX-UsdAssetResolver/actions/workflows/build_houdini.yml)
[![Build USD Asset Resolvers against Maya](https://github.com/LucaScheller/VFX-UsdAssetResolver/actions/workflows/build_maya.yml/badge.svg)](https://github.com/LucaScheller/VFX-UsdAssetResolver/actions/workflows/build_maya.yml)

This repository holds reference implementations for [Usd](https://openusd.org/release/index.html) [asset resolvers](https://openusd.org/release/glossary.html#usdglossary-assetresolution). The resolvers are compatible with the AR 2.0 standard proposed in the [Asset Resolver 2.0 Specification](https://openusd.org/release/wp_ar2.html). As the Usd documentation offers quite a good overview over the overall asset resolution system, we will not be covering it in this repository's documentation.

[ 该存储库包含  [Usd](https://openusd.org/release/index.html) [asset resolvers](https://openusd.org/release/glossary.html#usdglossary-assetresolution) 的参考实现. 解析器与 [Asset Resolver 2.0 Specification](https://openusd.org/release/wp_ar2.html) 中提出的 AR 2.0 标准兼容. 由于 USD 文档对整个资产解析系统提供了相当好的概述，因此我们不会在此存储库的文档中对其进行介绍 ]

## Installation [ 安装]
To build the various resolvers, follow the instructions in the [install guide](https://lucascheller.github.io/VFX-UsdAssetResolver/installation/requirements.html).

[ 要构建各种解析器，请按照 [安装指南](https://lucascheller.github.io/VFX-UsdAssetResolver/installation/requirements.html) 中的说明进行操作]

> [!NOTE]
> This guide currently covers compiling against standalone/Houdini/Maya/Nuke on Linux and Windows. Alternatively you can also download a pre-compiled builds on our [release page](https://github.com/LucaScheller/VFX-UsdAssetResolver/releases) (except for Nuke). To load the resolver, you must specify a few environment variables, see our [environment variables](https://lucascheller.github.io/VFX-UsdAssetResolver/resolvers/overview.html#environment-variables) section for more details.

[本指南目前涵盖了在Linux和Windows上针对独立/Houdini/Maya/Nuke进行编译。或者，您也可以在我们的[发布页面]上下载预编译的版本(https://github.com/LucaScheller/VFX-UsdAssetResolver/releases)（Nuke除外）。要加载解析器，您必须指定一些环境变量，请参阅我们的[环境变量](https://lucascheller.github.io/VFX-UsdAssetResolver/resolvers/overview.html#environment-变量）部分了解更多详细信息。]

> [!IMPORTANT]
> We also offer a quick install method for Houdini/Maya that does the download of the compiled resolvers and environment variable setup for you. This is ideal if you want to get your hands dirty right away and you don't have any C++ knowledge or extensive USD developer knowledge. If you are a small studio, you can jump right in and play around with our resolvers and prototype them further to make it fit your production needs.\
 [ 我们还为 Houdini/Maya 提供了一种快速安装方法，可以为您下载已编译的解析器和环境变量设置. 如果您想立即开始操作, 并且没有任何 C++ 知识或大量 USD 开发知识那么这是理想的选择. 如果您是一家小型工作室，您可以直接使用我们的解析器并对其进行进一步原型设计以使其满足您的制作需求]

To run the "Update Manager" simply run this snippet in the Houdini "Python Source Editor" or Maya "Script Editor" panel:

[ 要运行 “Update Manager” 只需在 Houdini “Python Source Editor” 或 Maya “Script Editor” 面板中运行以下代码段]

    import ssl; from urllib import request
    update_manager_url = 'https://raw.githubusercontent.com/LucaScheller/VFX-UsdAssetResolver/main/tools/update_manager.py?token=$(date+%s)'
    exec(request.urlopen(update_manager_url,context=ssl._create_unverified_context()).read(), globals(), locals())
    run_dcc()
    
See our [Automatic Installation](https://lucascheller.github.io/VFX-UsdAssetResolver/installation/automatic_install.html) section for more information.

[ 有关更多信息请参阅我们的 [自动安装](https://lucascheller.github.io/VFX-UsdAssetResolver/installation/automatic_install.html) 部分]

## Feature Overview [功能概述]
Asset resolvers that can be compiled via this repository:

[ 可以通过此存储库编译资产解析器]
- **Production Resolvers [ 生产可用的解析器]**
    - **File Resolver** - A file system based resolver similar to the default resolver with support for custom mapping pairs as well as at runtime modification and refreshing.

        [ File Resolver: 基于文件系统的解析器，类似于默认解析器，支持自定义映射键值对以及运行时修改和刷新]
    - **Cached Resolver** - A resolver that first consults an internal resolver context dependent cache to resolve asset paths. If the asset path is not found in the cache, it will redirect the request to Python and cache the result. This is ideal for smaller studios, as this preserves the speed of C++ with the flexibility of Python.

        [ Cached Resolver: 它首先通过查询内部解析器上下文的缓存来解析资产路径.如果资产路径在缓存中找不到，它会将请求重定向到 Python 并缓存结果. 这对于小型工作室来说非常理想，因为它既保留了 C++ 的速度，又具备Python 的灵活性]
- **RnD Resolvers [研发 解析器]**
    - **Python Resolver** - Python based implementation of the file resolver. The goal of this resolver is to enable easier RnD by running all resolver and resolver context related methods in Python. It can be used to quickly inspect resolve calls and to setup prototypes of resolvers that can then later be re-written in C++ as it is easier to code database interactions in Python for initial research.

        [ Python Resolver: 基于 Python 的文件解析器实现. 该解析器的目标是通过在 Python 中运行所有与解析器和解析器上下文相关的方法，来使研发变得更加容易. 它可用于快速检查解析调用，并设置解析器的原型，随后可以用 C++ 重写这些原型，因为对于初步研究来说，在 Python 中编写数据库交互代码更为简单]
- **Proof Of Concept Resolvers [概念性 解析器]**
    - **Http Resolver** - A proof of concept http resolver. This is kindly provided and maintained by @charlesfleche in the [arHttp: Offloads USD asset resolution to an HTTP server
    ](https://github.com/charlesfleche/arHttp) repository. For documentation, feature suggestions and bug reports, please file a ticket there. This repo handles the auto-compilation against DCCs and exposing to the automatic installation update manager UI.

        [ Http Resolver: 一个概念性的 HTTP 解析器.这个解析器由 @charlesfleche 维护在  [arHttp: Offloads USD asset resolution to an HTTP server](https://github.com/charlesfleche/arHttp) 有关文档、功能建议和错误报告，请在那里提交. 此存储库处理针对 DCC 的自动编译并公开给自动安装更新管理器 UI]

For more information check out the [building guide](https://lucascheller.github.io/VFX-UsdAssetResolver/installation/building.html) as well as the [individual resolvers](https://lucascheller.github.io/VFX-UsdAssetResolver/resolvers/overview.html) to see their full functionality.

[ 有关更多信息，请查看 [构建指南](https://lucascheller.github.io/VFX-UsdAssetResolver/installation/building.html) 以及 [各个解析器](https://lucascheller.github.io/VFX-UsdAssetResolver/resolvers/overview.html) 以了解其完整功能]

## Tutorials [ 教程]
We also have video tutorials covering how to (build and) install the resolvers in this repository as well as how you can customize them to fit your needs.
You can check them out in our [tutorials section](https://lucascheller.github.io/VFX-UsdAssetResolver/tutorials/overview.html) or on [Youtube](https://www.youtube.com/watch?v=y4FjYprM4oA&list=PLiu1hwgXfcszQXU1WU0Ucsc2o9Fz8zLsL)/[Vimeo](https://vimeo.com/showcase/10771710).

[ 我们还有视频教程，介绍如何在此存储库中（构建和）安装解析器以及如何自定义它们以满足您的需求. 您可以在我们的 [教程部分](https://lucascheller.github.io/VFX-UsdAssetResolver/tutorials/overview.html) 或 [Youtube](https://www.youtube.com/watch?v=y4FjYprM4oA&list=PLiu1hwgXfcszQXU1WU0Ucsc2o9Fz8zLsL)/[Vimeo](https://vimeo.com/showcase/10771710) 上查看它们]

## Contributing and Acknowledgements [贡献和致谢]
Special thanks to [Jonas Sorgenfrei](https://github.com/jonassorgenfrei) for helping bring this project to life as well as all the contributors on the Usd-Interest forum, particularly
Mark Tucker, ColinE, Jake Richards, Pawel Olas, Joshua Miller US, Simon Boorer, @dovanbel and @marcantoinep. 

[ 特别感谢 [Jonas Sorgenfrei](https://github.com/jonassorgenfrei) 帮助实现该项目，以及 USD-Interest 论坛上的所有贡献者，特别是 Mark Tucker, ColinE, Jake Richards, Pawel Olas, Joshua Miller US, Simon Boorer]

Post of relevance in the Usd-Interest Forum to this repo:

[ 在 Usd-Interest 论坛中与这个仓库相关的帖子]
- [usdResolverExample AR 2.0 for Houdini 19.5](https://groups.google.com/g/usd-interest/c/82GxMaAG1eo/m/ePk2tYptAAAJ)
- [USD Asset Resolver Python](https://groups.google.com/g/usd-interest/c/60e5aQgW_gg/m/DfCcN_1oAwAJ)
- [AR 2.0: CreateDefaultContextForAsset replacement?
](https://groups.google.com/g/usd-interest/c/7Aqv3k-V_DU/m/HPz7dSZLBQAJ)

Please consider contributing back to the Usd project in the  official [USD Repository](https://github.com/PixarAnimationStudios/USD) and via the [USD User groups](https://wiki.aswf.io/display/WGUSD/USD+Working+Group).

[ 请考虑通过官方 [Usd Repository](https://github.com/PixarAnimationStudios/USD) 和 [Usd User groups](https://wiki.aswf.io/display/WGUSD/USD+Working+Group) 向 Usd 项目贡献您的力量]

Feel free to fork this repository and share improvements or further resolvers.
If you run into issues, please flag them by [submitting a ticket](https://github.com/LucaScheller/VFX-UsdAssetResolver/issues/new).

[ 请随意复制这个仓库，并分享您的改进或进一步的解析器. 如果您遇到任何问题请 [submitting a ticket](https://github.com/LucaScheller/VFX-UsdAssetResolver/issues/new)]
