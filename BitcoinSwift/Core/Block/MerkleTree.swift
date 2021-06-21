//
//  MerkleTree.swift
//  BitcoinSwift
//
//  Created by FlamingHoneyBadger on 6/20/21.
//

import Foundation


class MerkleTree {
    let total : UInt32
    let maxDepth : UInt32
    var nodes : [[Data?]]
    var nodeCount : Int = 0
    var currentIndex : Int
    var currentDepth : Int
    
    init(total: UInt32) {
        self.total = total
        self.maxDepth =  UInt32(log2(Double(total)).rounded(FloatingPointRoundingRule.up))
        nodes = []
        
        
        for depth in (0..<self.maxDepth+1) {
            
            let numItems = (Double(total) / pow(Double(2), Double(maxDepth - depth))).rounded(FloatingPointRoundingRule.up)
            
            var levelHashes : [Data?] = []
            
            for _ in 0..<Int(numItems) {
                levelHashes.append(nil)
            }
            
            nodes.append(levelHashes)
            nodeCount += levelHashes.count
        }
        
        self.currentIndex = 0
        self.currentDepth = 0
        
        
    }
    
    
    func populateTree(flagBits: inout [Bool] , hashes:inout [Data])  throws {
        var rightHash : Data?
        var leftHash : Data?

        while self.root() == nil {
            
            if self.isLeaf() {
                _ = flagBits.removeFirst()
                setCurrentNode(value: hashes.removeFirst())
                up()
            }else{
                let leftHash = leftNode()
                
                if leftHash == nil {
                    if(!(flagBits.removeFirst())) {
                        setCurrentNode(value: hashes.removeFirst())
                        up()
                    }else{
                        left()
                    }
                }else if rightExists() {
                    rightHash = rightNode()
                    
                    if rightHash == nil {
                        right()
                    }else {
                        setCurrentNode(value: Helper.merkleParent(hash1: leftHash ?? Data(), hash2: rightHash ?? Data()))
                        up()
                    }
                }else{
                    setCurrentNode(value: Helper.merkleParent(hash1: leftHash ?? Data(), hash2: leftHash ?? Data()))
                    up()
                }
            }
        }
            if hashes.count != 0 {
                throw MerkleTreeErrors.populateHashesNotConsumed
            }
            if flagBits.count != 0 {
                throw MerkleTreeErrors.populateHashesNotConsumed
            }
            
            
        
        
    }
    
    func isLeaf() -> Bool{
        currentDepth == maxDepth
    }
    
    func root() -> Data? {
        nodes[0][0]
    }
    
    func up(){
        currentDepth -= 1
        currentIndex = Int(Double((currentIndex)  / 2).rounded(.down))
    }
    
    func left(){
        currentDepth += 1
        currentIndex *= 2
    }
    
    func right() {
        currentDepth += 1
        currentIndex = currentIndex * 2 + 1
    }
    
    func setCurrentNode(value: Data?) {
        nodes[currentDepth][currentIndex] = value
    }
    
    func getCurrentNode() -> Data? {
        nodes[currentDepth][currentIndex]
    }
    
    func leftNode() -> Data? {
        nodes[currentDepth + 1][currentIndex * 2]
    }
    
    func rightNode() -> Data? {
        nodes[currentDepth + 1][currentIndex * 2 + 1]
    }
    
    func rightExists() -> Bool {
        nodes[currentDepth + 1].count > (currentIndex * 2 + 1)
    }
    
    
}

enum MerkleTreeErrors : Error{
    case populateHashesNotConsumed
    case populateFlagsNotConsumed
}
