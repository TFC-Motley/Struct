import BT "Buffer/Types";

module {

  public type Field = BT.Field;

  public type Value = BT.Value;

  public type Schema = BT.Schema;

  public type Register = [Value];

  public type Return<T> = BT.Return<T>;

  public type Struct = {
    schema: () -> Schema;
    byte_count: () -> Nat;
    field_count: () -> Nat;
    signature: () -> Nat32;
    pack: (Register) -> ?Blob;
    unpack: (Blob) -> ?Register;
  };

}