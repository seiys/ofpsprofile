# ofpsprofile
以下の環境でopenFrameworksを楽しむためのPowerShellプロファイル
- OS：Windows
- ビルダ：Visual Studio
- エディタ：Visual Studio Code
<br />

PowerShellのコマンドにて以下を実現
- 任意のディレクトリにおけるopenFrameworksプロジェクトの作製
  - プロジェクトの初期設定とアドオンの追加
  - Visual Studio Code用のセッティング
- openFrameworksプロジェクトのビルド
<br />

## 使い方

### 準備
1. openFrameworksをVisual Studio向けにセットアップ
- ダウンロード：https://openframeworks.cc/download/
- セットアップ手順：https://openframeworks.cc/setup/vs/
<br />

2. 任意のディレクトリに次の構成にてファイルを配置
```
[任意のディレクトリ]/
　├ oFconfig
　├ oFprofile.ps1
　└ oFvscode_temp/
     └ c_cpp_properties.json
   　└ temp.code-workspace
```
<br />

3. oFconfigにXML形式にて以下を記入
- openFrameworksのフォルダの絶対パス
- MSBuild.exeの絶対パス
- Visual Studioのプラットフォームツールセットのバージョン

例）
```
<?xml version="1.0" encoding="UTF-8"?>
<config>
    <oFPath>C:\openFrameworks\of_v0.11.2_vs2017_release</oFPath>
    <MSBuildPath>C:\`"Program Files`"\`"Microsoft Visual Studio`"\2022\Community\Msbuild\Current\Bin\MSBuild.exe</MSBuildPath>
    <PlatformToolset>v143</PlatformToolset>
</config>
```
<br />

4. ```$profile```：```C:\Users\[username]\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1```に以下を記述
```
."[oFprofile.ps1を保存したパス]\oFprofile.ps1"
```
<br />

### PowerShellコマンド
<table>
<tr>
    <td>コマンド</td>
    <td>引数</td>
    <td>挙動</td>
    <td>実行ディレクトリ</td>
</tr>
<tr>
    <td><code>ofinit</code></td>
    <td><code>プロジェクト名</code></td>
    <td>指定した名前のプロジェクトを作製</td>
    <td rowspan="2">プロジェクトフォルダの親ディレクトリ</td>
</tr>
<tr>
    <td><code>ofcode</code></td>
    <td><code>プロジェクト名</code></td>
    <td>指定した名前のプロジェクトを，Visual Studio Codeにて開く<br />その後，プロジェクトフォルダに移動</td>
</tr>
<tr>
    <td rowspan="3"><code>ofaddon</code></td>
    <td>なし</td>
    <td>アドオンの一覧を表示</td>
    <td rowspan="11">プロジェクトフォルダ内</td>
</tr>
<tr>
    <td><code>list</code></td>
    <td>適応済みのアドオンのリストを表示</td>
</tr>
<tr>
    <td><code>apply "[アドオン1,アドオン2,...,アドオンn]"</code></td>
    <td>指定したアドオンを適応してプロジェクトを更新<br/>未指定の場合，アドオンなしでプロジェクトを更新<br/>アドオンを追加する場合，適応済みのものを含めて指定する必要あり</td>
</tr>
<tr>
    <td rowspan="6"><code>ofbuild</code></td>
    <td>なし もしくは <code>db</code></td>
    <td>プロジェクトをデバッグビルド</td>
</tr>
<tr>
    <td><code>dbr</code></td>
    <td>プロジェクトをデバッグビルドした後実行</td>
</tr>
<tr>
    <td><code>dc</code></td>
    <td>プロジェクトのデバッグビルドをクリーン</td>
</tr>
<tr>
    <td><code>rb</code></td>
    <td>プロジェクトをリリースビルド</td>
</tr>
<tr>
    <td><code>rbr</code></td>
    <td>プロジェクトをリリースビルドした後実行</td>
</tr>
<tr>
    <td><code>rc</code></td>
    <td>プロジェクトのリリースビルドをクリーン</td>
</tr>
<tr>
    <td rowspan="2"><code>ofrun</code></td>
    <td>なし もしくは <code>d</code></td>
    <td>デバッグビルド済みの実行ファイルを起動</td>
</tr>
<tr>
    <td><code>r</code></td>
    <td>リリースビルド済みの実行ファイルを起動</td>
</tr>
</table>

## 解決しそうな課題
- Visual Studio Codeを使用した環境構築
- 任意のディレクトリにおけるプロジェクト作製
