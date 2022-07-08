

# about event redirect

Event redirection is events merge.

For operations on the same row, 
you can reduce I/O operations by merging events.

Merged event operate may change.



row state

- exist
- not-exist


sql operate 

- INSERT
- DELETE
- UPDATE


cdc operate

| cdc | INSERT | DELETE | UPDATE |
|:-----:|:-----:|:-----:|:-----:|
| debezium | c/r | d | u/r-incremental |
| canal | INSERT | DELETE | UPDATE |

The operation is limited by the row state

| row state  | INSERT | DELETE | UPDATE |
|:-----:|:-----:|:-----:|:-----:|
| exist | ⛔ | ✅ | ✅ |
| not-exist | ✅ | ⛔ | ⛔ |

The operation can change row state

| operate  | row state before | row state after | 
|:-----:|:-----:|:-----:|
| INSERT | not-exist | exist |
| DELETE | exist | not-exist |
| UPDATE | exist | exist |

Merged events are determined by first and last events

| first operate | last operate | merged operate | 
|:-----:|:-----:|:-----:|
| INSERT | INSERT | INSERT |
|  | DELETE | NONE |
|  | UPDATE | INSERT |
| DELETE | INSERT | UPDATE |
|  | DELETE | DELETE |
|  | UPDATE | UPDATE |
| UPDATE | INSERT | UPDATE |
|  | DELETE | DELETE |
|  | UPDATE | UPDATE |