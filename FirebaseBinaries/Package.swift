// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FirebaseBinaries",
    products: [
        .library(
            name: "FirebaseBinaries",
            targets: [
                "FBLPromises",
                "FirebaseAnalytics",
                "FirebaseAnalyticsSwift",
                "FirebaseCore",
                "FirebaseCoreInternal",
                "FirebaseInstallations",
                "GoogleAppMeasurement",
                "GoogleAppMeasurementIdentitySupport",
                "GoogleUtilities",
                "nanopb",
                
                "FirebaseCrashlytics",
                "GoogleDataTransport",
                
                "abseil",
                "BoringSSL-GRPC",
                "FirebaseCoreExtension",
                "FirebaseFirestore",
                "FirebaseFirestoreSwift",
                "FirebaseSharedSwift",
                "gRPC-C++",
                "gRPC-Core",
                "leveldb-library",
                "Libuv-gRPC",
            ])
    ],
    targets: [
        .binaryTarget(name: "FBLPromises", path: "Frameworks/FirebaseAnalytics/FBLPromises.xcframework"),
        .binaryTarget(name: "FirebaseAnalytics", path: "Frameworks/FirebaseAnalytics/FirebaseAnalytics.xcframework"),
        .binaryTarget(name: "FirebaseAnalyticsSwift", path: "Frameworks/FirebaseAnalytics/FirebaseAnalyticsSwift.xcframework"),
        .binaryTarget(name: "FirebaseCore", path: "Frameworks/FirebaseAnalytics/FirebaseCore.xcframework"),
        .binaryTarget(name: "FirebaseCoreInternal", path: "Frameworks/FirebaseAnalytics/FirebaseCoreInternal.xcframework"),
        .binaryTarget(name: "FirebaseInstallations", path: "Frameworks/FirebaseAnalytics/FirebaseInstallations.xcframework"),
        .binaryTarget(name: "GoogleAppMeasurement", path: "Frameworks/FirebaseAnalytics/GoogleAppMeasurement.xcframework"),
        .binaryTarget(name: "GoogleAppMeasurementIdentitySupport", path: "Frameworks/FirebaseAnalytics/GoogleAppMeasurementIdentitySupport.xcframework"),
        .binaryTarget(name: "GoogleUtilities", path: "Frameworks/FirebaseAnalytics/GoogleUtilities.xcframework"),
        .binaryTarget(name: "nanopb", path: "Frameworks/FirebaseAnalytics/nanopb.xcframework"),
        
        .binaryTarget(name: "FirebaseCrashlytics", path: "Frameworks/FirebaseCrashlytics/FirebaseCrashlytics.xcframework"),
        .binaryTarget(name: "GoogleDataTransport", path: "Frameworks/FirebaseCrashlytics/GoogleDataTransport.xcframework"),
        
        .binaryTarget(name: "abseil", path: "Frameworks/FirebaseFirestore/abseil.xcframework"),
        .binaryTarget(name: "BoringSSL-GRPC", path: "Frameworks/FirebaseFirestore/BoringSSL-GRPC.xcframework"),
        .binaryTarget(name: "FirebaseCoreExtension", path: "Frameworks/FirebaseFirestore/FirebaseCoreExtension.xcframework"),
        .binaryTarget(name: "FirebaseFirestore", path: "Frameworks/FirebaseFirestore/FirebaseFirestore.xcframework"),
        .binaryTarget(name: "FirebaseFirestoreSwift", path: "Frameworks/FirebaseFirestore/FirebaseFirestoreSwift.xcframework"),
        .binaryTarget(name: "FirebaseSharedSwift", path: "Frameworks/FirebaseFirestore/FirebaseSharedSwift.xcframework"),
        .binaryTarget(name: "gRPC-C++", path: "Frameworks/FirebaseFirestore/gRPC-C++.xcframework"),
        .binaryTarget(name: "gRPC-Core", path: "Frameworks/FirebaseFirestore/gRPC-Core.xcframework"),
        .binaryTarget(name: "leveldb-library", path: "Frameworks/FirebaseFirestore/leveldb-library.xcframework"),
        .binaryTarget(name: "Libuv-gRPC", path: "Frameworks/FirebaseFirestore/Libuv-gRPC.xcframework"),
    ]
)
