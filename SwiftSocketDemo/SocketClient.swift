//
//  SocketClient.swift
//  SwiftSocketDemo
//
//  Created by Harvey He on 2019/9/9.
//  Copyright © 2019 Harvey He. All rights reserved.
//

import UIKit

class SocketClient: NSObject {
    private var socketClient: Int32 = -1
    private var connectSource: DispatchSourceWrite? = nil
    /**
     参数
     domain:    协议域，AF_INET（IPV4的网络开发）
     type:      Socket 类型，SOCK_STREAM(TCP)/SOCK_DGRAM(UDP，报文)
     protocol:  IPPROTO_TCP，协议，如果输入0，可以根据第二个参数，自动选择协议
     */
    
    func connectTo(_ address: String, port:Int) -> Bool {
        print("conneting...")
        socketClient = socket(AF_INET, SOCK_STREAM,0)
        
        if(socketClient == -1){
            print("fail to create")
        }
        
        var client_addr = sockaddr_in()
        let client_addr_size = socklen_t(MemoryLayout.size(ofValue: client_addr))
        client_addr.sin_len = UInt8(client_addr_size)
        inet_pton(AF_INET, address, &(client_addr.sin_addr));
        client_addr.sin_family = sa_family_t(AF_INET) // chooses IPv4
        client_addr.sin_port = in_port_t((CUnsignedShort(port).bigEndian))
        return withUnsafePointer(to: &client_addr) {
            let result = connect(self.socketClient, UnsafeRawPointer($0).assumingMemoryBound(to: sockaddr.self), client_addr_size)
            return (result == 0)
        }
    }
    
    func sendData(message:String) {
        let strings = (message as NSString).utf8String
        send(self.socketClient,strings, strlen(strings!), 0)
    }
    
    func readData() {
        let size = PacketBase.headerSize
        var totalReadCount = 0
        var buf = [UInt8](repeating: 0, count: size)
        var data = Data(capacity: size)
        let readCount = read(socketClient, &buf, size - totalReadCount)
        totalReadCount += readCount
        data.append(buf, count:readCount)
        print(data)
    }
}
