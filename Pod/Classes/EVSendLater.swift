//
//  EVSendLater.swift
//  Pods
//
//  Created by Lorenzo Rey Vergara on 08/10/2015.
//
//

open class EVSendLater : NSObject {
    
    fileprivate var saves:NSMutableDictionary!
    fileprivate var savesChanged = false
    fileprivate var savesCreated = false
    fileprivate let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("EVSendLaters")
    open var saveImmediately = false
    
    open class var sharedManager : EVSendLater {
        struct Static {
            static let instance : EVSendLater = EVSendLater()
            
        }
        Static.instance.initializeSaves()
        return Static.instance
    }
    
    fileprivate func initializeSaves(){
        if !savesCreated{
            let fileManager = FileManager.default
            
            if !fileManager.fileExists(atPath: path){
                saves = NSMutableDictionary()
            } else{
                saves = NSMutableDictionary(contentsOfFile: path)
            }
            savesCreated = true
        }
        
    }
    
    
    open func saveForLater(_ url:String, params:[AnyHashable: Any]){
        if let list = saves.object(forKey: url) as? NSMutableArray{
            list.add(params)
        } else{
            saves.setObject(NSMutableArray(array: [params]), forKey: url as NSCopying)
        }
        
        setSavesChanged()
    }
    
    open func synchronizeSaves(){
        if savesChanged{
            savesChanged = !saves.write(toFile: path, atomically: true)
        }
    }
    
    open func getSavesForUrl(_ url:String, delete:Bool) -> [[String:AnyObject]]?{
        return (saves.object(forKey: url)? as AnyObject).copy() as? [[String:AnyObject]]
    }
    
    open func getAllSaves() -> NSDictionary{
        return saves
    }
    
    open func removeFromSaves(_ url:String, params:[String:AnyObject]){
        if let array = saves.object(forKey: url) as? NSMutableArray{
            array.remove(params)
            setSavesChanged()
        }
    }
    
    func setSavesChanged(){
        savesChanged = true
        if saveImmediately{
            synchronizeSaves()
        }
    }
}
