import 'dart:io';
import 'package:photo_manager/photo_manager.dart';

class MediaService {
  MediaService() {
    //PhotoManager.forceOldApi();
  }
  Future<List<AssetPathEntity>> getVideoAssetFolders() async {
    List<AssetPathEntity> list = await PhotoManager.getAssetPathList(
        type: RequestType.video, hasAll: true);
    return list;
  }

  Future<List<AssetPathEntity>> getImageAssetFolders() async {
    List<AssetPathEntity> list =
        await PhotoManager.getAssetPathList(type: RequestType.image);
    return list;
  }

  Future<List<AssetEntity>> getFolderContents(
      AssetPathEntity assetPathEntity) async {
    List<AssetEntity> assetEntity = await assetPathEntity.assetList;
    return assetEntity;
  }
}
