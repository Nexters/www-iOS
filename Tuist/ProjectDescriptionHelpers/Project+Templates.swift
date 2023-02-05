import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    /// Helper function to create the Project for this ExampleApp
//    public static func app(
//        name: String,
//        platform: Platform,
//        additionalTargets: [String]
//    ) -> Project {
//            var targets = makeAppTargets(name: name,
//                                         platform: platform,
//                                         dependencies: additionalTargets.map { TargetDependency.target(name: $0) })
//            targets += additionalTargets.flatMap({ makeFrameworkTargets(name: $0, platform: platform) })
//            return Project(name: name,
//                           organizationName: "tuist.io",
//                           targets: targets)
//        }

    // custom
    public static func makeAppModule(
        name: String,
        platform: Platform = .iOS,
        product: Product,
        organizationName: String = "com.promise8",
        packages: [Package] = [],
        deploymentTarget: DeploymentTarget? = .iOS(targetVersion: "15.0", devices: [.iphone]),
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        infoPlist: InfoPlist = .default
    ) -> Project {
        
//        let settings: Settings = .settings(base: fireBaseAnalyticsSetting,
//            configurations: [
//                .debug(name: .debug, xcconfig: .relativeToRoot("config.xcconfig")),
//                .release(name: .release, xcconfig: .relativeToRoot("config.xcconfig"))
//            ], defaultSettings: .recommended)

        let appTarget = Target(
            name: name,
            platform: platform,
            product: product,
            bundleId: "\(organizationName).\(name)",
            deploymentTarget: deploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            dependencies: dependencies
        )
        
        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "\(organizationName).\(name)Tests",
            deploymentTarget: deploymentTarget,
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: name)]
        )
        
        let schemes: [Scheme] = [.makeScheme(target: .debug, name: name)]
        
        let targets: [Target] = [appTarget, testTarget]
        
        return Project(
            name: name,
            organizationName: organizationName,
            packages: packages,
//            settings: settings,
            targets: targets,
            schemes: schemes
        )
    }

    
    
    // MARK: - Private
//
//    /// Helper function to create a framework target and an associated unit test target
//    private static func makeFrameworkTargets(name: String, platform: Platform) -> [Target] {
//        let sources = Target(name: name,
//                platform: platform,
//                product: .framework,
//                bundleId: "io.tuist.\(name)",
//                infoPlist: .default,
//                sources: ["Targets/\(name)/Sources/**"],
//                resources: [],
//                dependencies: [])
//        let tests = Target(name: "\(name)Tests",
//                platform: platform,
//                product: .unitTests,
//                bundleId: "io.tuist.\(name)Tests",
//                infoPlist: .default,
//                sources: ["Targets/\(name)/Tests/**"],
//                resources: [],
//                dependencies: [.target(name: name)])
//        return [sources, tests]
//    }
//
//    /// Helper function to create the application target and the unit test target.
//    private static func makeAppTargets(name: String, platform: Platform, dependencies: [TargetDependency]) -> [Target] {
//        let platform: Platform = platform
//        let infoPlist: [String: InfoPlist.Value] = [
//            "CFBundleShortVersionString": "1.0",
//            "CFBundleVersion": "1",
//            "UILaunchStoryboardName": "LaunchScreen"
//            ]
//
//        let mainTarget = Target(
//            name: name,
//            platform: platform,
//            product: .app,
//            bundleId: "io.tuist.\(name)",
//            infoPlist: .extendingDefault(with: infoPlist),
//            sources: ["Targets/\(name)/Sources/**"],
//            resources: ["Targets/\(name)/Resources/**"],
//            dependencies: dependencies
//        )
//
//        let testTarget = Target(
//            name: "\(name)Tests",
//            platform: platform,
//            product: .unitTests,
//            bundleId: "io.tuist.\(name)Tests",
//            infoPlist: .default,
//            sources: ["Targets/\(name)/Tests/**"],
//            dependencies: [
//                .target(name: "\(name)")
//        ])
//        return [mainTarget, testTarget]
//    }
}

extension Scheme {
    static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
        return Scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
}
