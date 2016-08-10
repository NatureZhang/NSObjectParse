
Pod::Spec.new do |s|
s.name         = "NSObjectParse"                #名称
s.version      = "0.0.1"                #版本号
s.summary      = "Transfers between dictionary model"        #简短介绍
s.homepage     = "http://www.baidu.com/"
s.license      = "MIT"                #开源协议
s.author             = { "NatureZhang" => "895234387@qq.com" }
s.source       = { :git => "https://github.com/NatureZhang/NSObjectParse.git", :tag => s.version }
s.platform     = :ios, "7.0"            #支持的平台及版本，这里我们呢用swift，直接上9.0
s.requires_arc = true                    #是否使用ARC
s.source_files  = "NSObjectParse/JYNSObjectParse/*.{h,m}"    #OC可以使用类似这样"Classes/**/*.{h,m}"

# s.dependency "JSONKit", "~> 1.4"    #依赖关系，该项目所依赖的其他库，如果有多个可以写多个 s.dependency

end