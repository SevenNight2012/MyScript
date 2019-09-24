### 开源仓库发布工具使用
1. 将publish目录拷贝到项目根目录下
2. 在需要发布的工程目录下的build.gradle文件的最后一行添加    
    ```
        apply from: rootProject.file("publish/PublishConfig.gradle")
    ```
3. 在需要发布的工程目录下添加gradle.properties文件，配置内容参考 [示例](gradle.properties.simple)
4. 如需发布，选择AS右侧的gradle导航栏，找到要发布的工程，点开tasks，先运行other下的install任务
然后如果配置的platform=jcenter，那么选择publishing下的bintrayUpload任务，双击即可，等待运行完成，
如果配置的platform=maven，那么选择upload下的uploadArchives任务，双击即可
5. 添加文件，要求配置下环境变量，需要将bintray_user，bintray_apiKey等相关变量配置下，否则运行报错
所有环境变量：
    ```
    bintray_user        账号
    bintray_apiKey      apiKey
    NEXUS_USERNAME      maven仓库中的用户名
    NEXUS_PASSWORD      maven仓库中的用户密码
    MAVEN_REMOTE_URL    maven仓库地址(release)
    MAVEN_LOCAL_URL     maven仓库的本地姿势(release)
    ```
6. 暂时未配置snapshot的仓库地址，如有需要，可自行配置