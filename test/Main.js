const Main = artifacts.require('Main');

contract('Main', (accounts) => {
  it('create document', async () => {
    const i = await Main.new();
    await i.createDocument(0x123, [accounts[1], accounts[2]]);
    assert.deepEqual(await i.documentAuthors(0), [accounts[1], accounts[2], accounts[0]]);
    assert.equal(await i.isDocumentAuthor(0), true);
    assert.equal(await i.documentVersionCount(0), 1);
    assert.deepEqual(await i.documentVersion(0, 0), [
      '0x1230000000000000000000000000000000000000000000000000000000000000',
      accounts[0]
    ]);
    assert.deepEqual((await i.authorOfDocuments()).map(i => +i), [0]);
  });

  it('create documents', async () => {
    const i = await Main.new();
    await i.createDocument(0, []);
    await i.createDocument(0, [], { from: accounts[1] });
    assert.deepEqual((await i.authorOfDocuments()).map(i => +i), [0]);
    assert.deepEqual((await i.authorOfDocuments({ from: accounts[1] })).map(i => +i), [1]);
  });

  it('add version', async () => {
    const i = await Main.new();
    await i.createDocument(0, [accounts[1]]);
    await i.addVersion(0, 0x123, { from: accounts[1] });
    assert.equal(await i.documentVersionCount(0), 2);
    assert.deepEqual(await i.documentVersion(0, 1), [
      '0x1230000000000000000000000000000000000000000000000000000000000000',
      accounts[1]
    ]);
  });
});
