/* Copyright (c) 2014, Oracle and/or its affiliates. All rights reserved.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; version 2 of the License.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA */

/*
 * View: innodb_lock_waits
 *
 * Give a snapshot of which InnoDB locks transactions are waiting for.
 * The lock waits are order by the age of the lock descending.
 *
 * Versions: 5.1+ (5.1 requires InnoDB Plugin with I_S tables)
 *
 * mysql> SELECT * FROM x$innodb_lock_waits\G
 * *************************** 1. row ***************************
 *       wait_started: 2014-11-11 13:39:20
 *           wait_age: 00:00:07
 *       locked_table: `db1`.`t1`
 *       locked_index: PRIMARY
 *        locked_type: RECORD
 *     waiting_trx_id: 867158
 *        waiting_pid: 3
 *      waiting_query: UPDATE t1 SET val = val + 1 WHERE id = 2
 *    waiting_lock_id: 867158:2363:3:3
 *  waiting_lock_mode: X
 *    blocking_trx_id: 867157
 *       blocking_pid: 4
 *     blocking_query: UPDATE t1 SET val = val + 1 + SLEEP(10) WHERE id = 2
 *   blocking_lock_id: 867157:2363:3:3
 * blocking_lock_mode: X
 * 1 row in set (0.01 sec)
 *
 */

CREATE OR REPLACE
  ALGORITHM = TEMPTABLE
  DEFINER = 'root'@'localhost'
  SQL SECURITY INVOKER 
VIEW innodb_lock_waits (
  wait_started,
  wait_age,
  locked_table,
  locked_index,
  locked_type,
  waiting_trx_id,
  waiting_pid,
  waiting_query,
  waiting_lock_id,
  waiting_lock_mode,
  blocking_trx_id,
  blocking_pid,
  blocking_query,
  blocking_lock_id,
  blocking_lock_mode
) AS
SELECT r.trx_wait_started AS wait_started, TIMEDIFF(NOW(), r.trx_wait_started) AS wait_age,
       rl.lock_table AS locked_table,
       rl.lock_index AS locked_index,
       rl.lock_type AS locked_type,
       r.trx_id AS waiting_trx_id,
       r.trx_mysql_thread_id AS waiting_pid,
       sys.format_statement(r.trx_query) AS waiting_query,
       rl.lock_id AS waiting_lock_id,
       rl.lock_mode AS waiting_lock_mode,
       b.trx_id AS blocking_trx_id,
       b.trx_mysql_thread_id AS blocking_pid,
       sys.format_statement(b.trx_query) AS blocking_query,
       bl.lock_id AS blocking_lock_id,
       bl.lock_mode AS blocking_lock_mode
  FROM information_schema.INNODB_LOCK_WAITS w
       INNER JOIN information_schema.INNODB_TRX b    ON b.trx_id = w.blocking_trx_id
       INNER JOIN information_schema.INNODB_TRX r    ON r.trx_id = w.requesting_trx_id
       INNER JOIN information_schema.INNODB_LOCKS bl ON bl.lock_id = w.blocking_lock_id
       INNER JOIN information_schema.INNODB_LOCKS rl ON rl.lock_id = w.requested_lock_id
 ORDER BY r.trx_wait_started;

/*
 * View: x$innodb_lock_waits
 *
 * Give a snapshot of which InnoDB locks transactions are waiting for.
 * The lock waits are order by the age of the lock descending.
 *
 * Versions: 5.1+ (5.1 requires InnoDB Plugin with I_S tables)
 *
 * mysql> SELECT * FROM x$innodb_lock_waits\G
 * *************************** 1. row ***************************
 *       wait_started: 2014-11-11 13:39:20
 *           wait_age: 00:00:07
 *       locked_table: `db1`.`t1`
 *       locked_index: PRIMARY
 *        locked_type: RECORD
 *     waiting_trx_id: 867158
 *        waiting_pid: 3
 *      waiting_query: UPDATE t1 SET val = val + 1 WHERE id = 2
 *    waiting_lock_id: 867158:2363:3:3
 *  waiting_lock_mode: X
 *    blocking_trx_id: 867157
 *       blocking_pid: 4
 *     blocking_query: UPDATE t1 SET val = val + 1 + SLEEP(10) WHERE id = 2
 *   blocking_lock_id: 867157:2363:3:3
 * blocking_lock_mode: X
 * 1 row in set (0.01 sec)
 *
 */

CREATE OR REPLACE
  ALGORITHM = TEMPTABLE
  DEFINER = 'root'@'localhost'
  SQL SECURITY INVOKER 
VIEW x$innodb_lock_waits (
  wait_started,
  wait_age,
  locked_table,
  locked_index,
  locked_type,
  waiting_trx_id,
  waiting_pid,
  waiting_query,
  waiting_lock_id,
  waiting_lock_mode,
  blocking_trx_id,
  blocking_pid,
  blocking_query,
  blocking_lock_id,
  blocking_lock_mode
) AS
SELECT r.trx_wait_started AS wait_started, TIMEDIFF(NOW(), r.trx_wait_started) AS wait_age,
       rl.lock_table AS locked_table,
       rl.lock_index AS locked_index,
       rl.lock_type AS locked_type,
       r.trx_id AS waiting_trx_id,
       r.trx_mysql_thread_id AS waiting_pid,
       r.trx_query AS waiting_query,
       rl.lock_id AS waiting_lock_id,
       rl.lock_mode AS waiting_lock_mode,
       b.trx_id AS blocking_trx_id,
       b.trx_mysql_thread_id AS blocking_pid,
       b.trx_query AS blocking_query,
       bl.lock_id AS blocking_lock_id,
       bl.lock_mode AS blocking_lock_mode
  FROM information_schema.INNODB_LOCK_WAITS w
       INNER JOIN information_schema.INNODB_TRX b    ON b.trx_id = w.blocking_trx_id
       INNER JOIN information_schema.INNODB_TRX r    ON r.trx_id = w.requesting_trx_id
       INNER JOIN information_schema.INNODB_LOCKS bl ON bl.lock_id = w.blocking_lock_id
       INNER JOIN information_schema.INNODB_LOCKS rl ON rl.lock_id = w.requested_lock_id
 ORDER BY r.trx_wait_started;

