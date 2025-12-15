| <img src="https://raw.githubusercontent.com/LucaScheller/VFX-UsdAssetResolver/main/tools/UsdAssetResolver_Logo.svg?token=$(date%20+%s)" width="128"> |  <h1> USD Asset Resolver </h1> |
|--|--|

[![Deploy Documentation to GitHub Pages](https://github.com/LucaScheller/VFX-UsdAssetResolver/actions/workflows/mdbook.yml/badge.svg)](https://github.com/LucaScheller/VFX-UsdAssetResolver/actions/workflows/mdbook.yml)
[![Build USD Asset Resolvers against USD](https://github.com/LucaScheller/VFX-UsdAssetResolver/actions/workflows/build_standalone.yml/badge.svg)](https://github.com/LucaScheller/VFX-UsdAssetResolver/actions/workflows/build_standalone.yml)
[![Build USD Asset Resolvers against Houdini](https://github.com/LucaScheller/VFX-UsdAssetResolver/actions/workflows/build_houdini.yml/badge.svg)](https://github.com/LucaScheller/VFX-UsdAssetResolver/actions/workflows/build_houdini.yml)
[![Build USD Asset Resolvers against Maya](https://github.com/LucaScheller/VFX-UsdAssetResolver/actions/workflows/build_maya.yml/badge.svg)](https://github.com/LucaScheller/VFX-UsdAssetResolver/actions/workflows/build_maya.yml)

This repository holds reference implementations for [Usd](https://openusd.org/release/index.html) [asset resolvers](https://openusd.org/release/glossary.html#usdglossary-assetresolution). The resolvers are compatible with the AR 2.0 standard proposed in the [Asset Resolver 2.0 Specification](https://openusd.org/release/wp_ar2.html). As the Usd documentation offers quite a good overview over the overall asset resolution system, we will not be covering it in this repository's documentation. You can find a video tutorial [here](./tutorials.md) (or on [Youtube](https://www.youtube.com/watch?v=y4FjYprM4oA&list=PLiu1hwgXfcszQXU1WU0Ucsc2o9Fz8zLsL)/[Vimeo](https://vimeo.com/showcase/10771710)).

[ 该存储库包含  [Usd](https://openusd.org/release/index.html) [asset resolvers](https://openusd.org/release/glossary.html#usdglossary-assetresolution) 的参考实现. 解析器与 [Asset Resolver 2.0 Specification](https://openusd.org/release/wp_ar2.html) 中提出的AR 2.0标准兼容. 由于 USD 文档对整个资产解析系统提供了相当好的概述，因此我们不会在此存储库的文档中对其进行介绍. 您可以在[此处](./tutorials.md)（或在 [Youtube](https://www.youtube.com/watch?v=y4FjYprM4oA&list=PLiu1hwgXfcszQXU1WU0Ucsc2o9Fz8zLsL)/[Vimeo](https://vimeo.com/showcase/10771710) 上）找到视频教程]

## Installation [安装]
To build the various resolvers, follow the instructions in the [install guide](./installation/overview.md). 

[ 要构建各种解析器，请按照 [安装指南](./installation/overview.md) 中的说明进行操作]

```admonish info
This guide currently covers compiling against standalone/Houdini/Maya/Nuke on Linux and Windows. Alternatively you can also download pre-compiled builds on our [release page](https://github.com/LucaScheller/VFX-UsdAssetResolver/releases) (except for Nuke). To load the resolver, you must specify a few environment variables, see our [environment variables](./resolvers/overview.md#environment-variables) section for more details.

[本指南目前涵盖了在Linux和Windows上针对独立/Houdini/Maya/Nuke进行编译。或者，您也可以在我们的[发布页面]上下载预编译的版本(https://github.com/LucaScheller/VFX-UsdAssetResolver/releases)（Nuke除外）。要加载解析器，您必须指定一些环境变量，有关更多详细信息，请参阅我们的[环境变量]（./resolvers/overview.md#环境变量）部分]
```

```admonish tip
We also offer a quick install method for Houdini/Maya that does the download of the compiled resolvers and environment variable setup for you. This is ideal if you want to get your hands dirty right away and you don't have any C++ knowledge or extensive USD developer knowledge. If you are a small studio, you can jump right in and play around with our resolvers and prototype them further to make it fit your production needs. See our [Automatic Installation](./installation/automatic_install.md) section for more information.

[ 我们还为 Houdini/Maya 提供了一种快速安装方法，该方法会为您下载已编译的解析器并设置环境变量. 如果您想立即上手并且没有C++知识或大量的USD开发经验，那么这种方法非常理想. 如果您是一个小型工作室，您可以直接开始使用我们的解析器并进行进一步原型设计，以满足您的生产需求.请查看我们的 [自动安装](./installation/automatic_install.md) 部分以获取更多信息]
```

## Feature Overview [功能概述]
Asset resolvers that can be compiled via this repository:

[ 可以通过此存储库编译资产解析器]
{{#include ./resolvers/shared_features.md:resolverOverview}}

For more information check out the [building guide](./installation/building.md) as well as the [individual resolvers](./resolvers/overview.md) to see their full functionality.

[ 有关更多信息，请查看 [构建指南](./installation/building.md)以及各个 [解析器](./resolvers/overview.md) 以了解其完整功能]