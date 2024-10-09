import Foundation
import FirebaseDataConnect







public extension DataConnect {

  static var defaultConnector: DefaultConnector = {
    let dc = DataConnect.dataConnect(connectorConfig: DefaultConnector.connectorConfig, callerSDKType: .generated)
    return DefaultConnector(dataConnect: dc)
  }()

}

public class DefaultConnector {

  var dataConnect: DataConnect

  public static let connectorConfig = ConnectorConfig(serviceId: "macos", location: "us-central1", connector: "default")

  init(dataConnect: DataConnect) {
    self.dataConnect = dataConnect

    // init operations 
    
  }

  public func useEmulator(host: String = DataConnect.EmulatorDefaults.host, port: Int = DataConnect.EmulatorDefaults.port) {
    self.dataConnect.useEmulator(host: host, port: port)
  }

  // MARK: Operations


}
