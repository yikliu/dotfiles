
/** 

Implement hash table class
get(Key) -> Value
put(Key, Value) -> Bool, true if the value updated, false if not updated
remove(Key) -> Bool
size() -> Int
All 4 function O(1)
Assume Key class have a .hash() function and returns a long.

**/

public class HashTable<K, V> {

    private int N = SIZE; 
    public List<LinkedList<V>> values

    public HashTable() {
      values = new V[]();    
    }

    public void put(K key, V value) {
      long h = hash(key);
      int index = h / N; 
      int position = h % N; 
      LinkedList l = values[index];
      V v = l.head();
      while (v){
        v = v.next(); 
      }
      v.put(value);
    }
    
    public V get(key) {
      long h = hash(key);
      int index = h / N;
      int position = h % N;
      V v = values[index].head();
      while (v) {
        v = v.next();
      }
      return v.get();
    }

    public int size() {
     return values.length; 
    }
}
