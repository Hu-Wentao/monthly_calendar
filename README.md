# Monthly Calendar

# Table of Contents

1. 项目结构
    1.1 core 与 features
        core存放各个 features中重复的部分,例如本地存储,网络请求的实现,等等  
    1.2 features 的构成: (以 user 为例)  
        1.2.1 domain 域层  
            a. entities 实体类  
                [实体类示例](lib/features/user/domain/entities/user.dart#L8)  
                所有的
            b. repositories 抽象仓库类  
                域层中的repo类定义抽象的业务逻辑, 不涉及任何技术细节
            c. usecase 用例类
        1.2.2 data 数据层  
            a. sources 数据源类  
            b. models 模型类  
            c. repositories 抽象仓库实现类  
        1.2.3 presentation 表示层  
            a. pages 页面类  
            b. view_models 视图模型类  
            c. widgets 微件类

2. 插件的使用
    2.1 [如何使用**Equatable**插件?](lib/features/user/domain/entities/user.dart#L12)  
    2.2 [如何使用**BotToast**插件?](/lib/main.dart#L19)  
    2.3 [如何使用**AutoRouter**插件?](/lib/main.dart#L24)  
    2.4 [如何使用**GetIt**插件?](lib/core/presentation/sl_view.dart#L13)  
    2.5 [如何使用**injectable**插件?](lib/injection_container.dart#L13)

