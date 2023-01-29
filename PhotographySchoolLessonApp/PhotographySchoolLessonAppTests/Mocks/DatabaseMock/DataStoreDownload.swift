//
//  dataStoreDownloadOneItem.swift
//  PhotographySchoolLessonAppTests
//
//  Created by Ahmed Mohiy on 29/01/2023.
//

import Foundation
import AppModels

protocol DataStoreDownload {
    var downloaditems: [DownloadItemModel] {get set}
}

class DataStoreDownloadOneItemDownloaded: DataStoreDownload {
     var downloaditems: [DownloadItemModel] = [DownloadItemModel(id: 950,
                                                                    remoteVideoUrl: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4",
                                                                    localVideoUrl: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4",
                                                                    isDownloaded: true)]
}

class DataStoreDownloadTwoItemsSecondNotDownloaded: DataStoreDownload {
     var downloaditems: [DownloadItemModel] = [DownloadItemModel(id: 950,
                                                                    remoteVideoUrl: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4",
                                                                    localVideoUrl: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4",
                                                                    isDownloaded: true),
                                               DownloadItemModel(id: 951,
                                                                                                              remoteVideoUrl: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4",
                                                                                                              localVideoUrl: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4",
                                                                                                              isDownloaded: false)]
}


class DataStoreDownloadOneItemDownloadNotComplete: DataStoreDownload {
     var downloaditems: [DownloadItemModel] = [DownloadItemModel(id: 950,
                                                                    remoteVideoUrl: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4",
                                                                    localVideoUrl: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4",
                                                                    isDownloaded: false)]
}

class DataStoreDownloadOneItemNotDownloadedEmptyLocalUrl: DataStoreDownload {
     var downloaditems: [DownloadItemModel] = [DownloadItemModel(id: 950,
                                                                    remoteVideoUrl: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4",
                                                                    localVideoUrl: "",
                                                                    isDownloaded: false)]
}

// DataStoreDownload TwoI tems First Not Downloaded with Empty Local Url and the Second Not Downloaded
class DataStoreDownloadTwoItems: DataStoreDownload {
     var downloaditems: [DownloadItemModel] = [DownloadItemModel(id: 950,
                                                                    remoteVideoUrl: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4",
                                                                    localVideoUrl: "",
                                                                    isDownloaded: false),
                                               DownloadItemModel(id: 951,
                                                                                                              remoteVideoUrl: "https://embed-ssl.wistia.com/deliveries/43e444a344a8e49f68f39daf68b894527db66126/8fgafnkpm2.mp4",
                                                                                                              localVideoUrl: "",
                                                                                                              isDownloaded: false)]
}
