# Requirements [依赖需求]

## System dependencies
Currently building on Linux and Windows is documented.

[ 当前在 Linux 和 Windows 上的构建已被记录]

We use CMake as our build system and link against Houdini/Maya/Nuke to avoid having to compile our own version of Usd.

[ 我们使用 CMake 作为构建系统并链接到 Houdini/Maya/Nuke，以避免编译我们自己的 Usd 版本]

Alternatively our build script also supports compiling against a self-compiled USD build (or pre-compiled build as for example [provided by Nvidia](https://developer.nvidia.com/usd)).

[或者，我们的构建脚本还支持针对自编译的USD构建（或预编译的构建，例如[由Nvidia提供]）进行编译(https://developer.nvidia.com/usd))]

VFX DCC vendors try to keep in sync with the versions specified in the [VFX Reference Platform](https://vfxplatform.com), so if something doesn't work, first make sure that your software versions are supported.

[ VFX DCC 供应商尝试与 [VFX Reference Platform](https://vfxplatform.com) 中指定的版本保持同步，因此如果出现问题，请首先确保您的软件版本受支持]

```admonish warning
Since the Usd Asset Resolver API changed with the AR 2.0 standard proposed in the [Asset Resolver 2.0 Specification](https://openusd.org/release/wp_ar2.html), you can only compile against Houdini versions 19.5 and higher/Maya versions 2024 and higher.

[ 由于 Usd Asset Resolver API 随 Asset Resolver 2.0 规范中提出的 AR 2.0 标准而更改，因此您只能针对 Houdini 版本 19.5 及更高版本/Maya 2024 及更高版本进行编译]
```

```admonish warning
Certain applications (like Maya or Nuke) have additional build requirements, see our [building](./building.md) section for more information.
```

## Linux
```admonish success title=""
| Software               | Website                                                                | Min (Not Tested)     | Max (Tested)  |
|------------------------|------------------------------------------------------------------------|----------------------|---------------|
| gcc                    | [https://gcc.gnu.org](https://gcc.gnu.org/)                            | 11.2.1               | 13.1.1        |
| cmake                  | [https://cmake.org](https://cmake.org/)                                | 3.26.4               | 3.26.4        |
| SideFX Houdini         | [SideFX Houdini](https://www.sidefx.com)                               | 19.5                 | 21.0          |
| Autodesk Maya          | [Autodesk Maya](https://www.autodesk.com/ca-en/products/maya/overview) | 2024                 | 2026          |
| Autodesk Maya USD SDK  | [Autodesk Maya USD SDK](https://github.com/Autodesk/maya-usd)          | 0.27.0               | 0.33.0        |
| Foundry Nuke           | [Foundry Nuke](https://www.foundry.com/products/nuke-family)           | 16                   | 16            |
```

## Windows
```admonish success title=""
| Software               | Website                                                                            | Min (Not Tested)     | Max (Tested)  |
|------------------------|------------------------------------------------------------------------------------|----------------------|---------------|
|Visual Studio 16 2019   | [https://visualstudio.microsoft.com/vs/](https://visualstudio.microsoft.com/vs/)   | -                    | -             |
|Visual Studio 17 2022   | [https://visualstudio.microsoft.com/vs/](https://visualstudio.microsoft.com/vs/)   | -                    | -             |
| cmake                  | [https://cmake.org](https://cmake.org/)                                            | 3.26.4               | 3.26.4        |
| SideFX Houdini         | [SideFX Houdini](https://www.sidefx.com)                                           | 19.5                 | 21.0          |
| Autodesk Maya          | [Autodesk Maya](https://www.autodesk.com/ca-en/products/maya/overview)             | 2024                 | 2026          |
| Autodesk Maya USD SDK  | [Autodesk Maya USD SDK](https://github.com/Autodesk/maya-usd)                      | 0.27.0               | 0.33.0        |
| Foundry Nuke           | [Foundry Nuke](https://www.foundry.com/products/nuke-family)                       | 16                   | 16            |
```

When compiling against Houdini/Maya/Nuke on Windows, make sure you use the Visual Studio version that Houdini/Maya/Nuke was compiled with as noted in the [HDK](https://www.sidefx.com/docs/hdk/_h_d_k__intro__getting_started.html#HDK_Intro_Compiling_Intro_Windows)/[SDK](https://github.com/Autodesk/maya-usd)/Nuke documentation. You'll also need to install the [Visual Studio build tools](https://visualstudio.microsoft.com/downloads/?q=build+tools) that match the Visual Studio release if you want to run everything from the terminal.

[ 当针对 Houdini/Maya/Nuke 在 Windows 上编译时，请确保使用 Houdini/Maya/Nuke 编译时使用的 Visual Studio 版本，如 [HDK](https://www.sidefx.com/docs/hdk/_h_d_k__intro__getting_started.html#HDK_Intro_Compiling_Intro_Windows)/[SDK](https://github.com/Autodesk/maya-usd)/Nuke 文档中所述。如果您想从终端运行所有内容，还需要安装与 Visual Studio 版本匹配的 [Visual Studio 生成工具](https://visualstudio.microsoft.com/downloads/?q=build+tools)]