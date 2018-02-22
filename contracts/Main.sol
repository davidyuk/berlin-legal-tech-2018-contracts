pragma solidity ^0.4.17;

contract Main {
  struct Version {
    bytes32 content;
    address author;
  }

  struct Document {
    address[] authors;
    mapping(address => bool) isAuthor;
    Version[] versions;
  }

  Document[] documents;

  function documentAuthors(uint documentId) public view returns (address[]) {
    return documents[documentId].authors;
  }

  function isDocumentAuthor(uint documentId) public view returns (bool) {
    return documents[documentId].isAuthor[msg.sender];
  }

  function documentVersionCount(uint documentId) public view returns (uint) {
    return documents[documentId].versions.length;
  }

  function documentVersion(uint documentId, uint versionId) public view
  returns (bytes32 content, address author) {
    content = documents[documentId].versions[versionId].content;
    author = documents[documentId].versions[versionId].author;
  }

  function createDocument(bytes32 content, address[] authors) public {
    documents.length += 1;
    Document storage d = documents[documents.length - 1];
    d.authors = authors;
    for (uint i = 0; i < authors.length; i++) {
      d.isAuthor[authors[i]] = true;
    }
    d.authors.push(msg.sender);
    d.isAuthor[msg.sender] = true;
    d.versions.push(Version({ content: content, author: msg.sender }));
  }

  modifier author(uint documentId) {
    require(documents[documentId].isAuthor[msg.sender]);
    _;
  }

  function addVersion(uint documentId, bytes32 content) public author(documentId) {
    documents[documentId].versions.push(Version({ content: content, author: msg.sender }));
  }
}
