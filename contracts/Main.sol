pragma solidity ^0.4.17;

contract Main {
  struct Version {
    bytes32 content;
    address[] signedBy;
  }

  struct Document {
    address[] authors;
    mapping(address => bool) isAuthor;
    Version[] versions;
  }

  Document[] documents;
  mapping(address => uint[]) _authorOfDocuments;

  function documentAuthors(uint documentId) public view returns (address[]) {
    return documents[documentId].authors;
  }

  function documentVersionCount(uint documentId) public view returns (uint) {
    return documents[documentId].versions.length;
  }

  function authorOfDocuments() public view returns (uint[]) {
    return _authorOfDocuments[msg.sender];
  }

  function documentVersion(uint documentId, uint versionId) public view
  returns (bytes32 content, address[] signedBy) {
    content = documents[documentId].versions[versionId].content;
    signedBy = documents[documentId].versions[versionId].signedBy;
  }

  function createDocument(bytes32 content, address[] authors) public {
    uint documentId = documents.length;
    documents.length += 1;
    Document storage d = documents[documentId];
    d.authors = authors;
    for (uint i = 0; i < authors.length; i++) {
      d.isAuthor[authors[i]] = true;
       _authorOfDocuments[authors[i]].push(documentId);
    }
    d.authors.push(msg.sender);
    d.isAuthor[msg.sender] = true;
    _authorOfDocuments[msg.sender].push(documentId);
    addVersion(documentId, content);
  }

  modifier author(uint documentId) {
    require(documents[documentId].isAuthor[msg.sender]);
    _;
  }

  function addVersion(uint documentId, bytes32 content) public author(documentId) {
    Document storage d = documents[documentId];
    uint versionId = d.versions.length;
    d.versions.length += 1;
    d.versions[versionId].content = content;
    signVersion(documentId, versionId);
  }

  function signVersion(uint documentId, uint versionId) public author(documentId) {
    documents[documentId].versions[versionId].signedBy.push(msg.sender);
  }
}
