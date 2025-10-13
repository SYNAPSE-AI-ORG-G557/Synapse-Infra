#!/usr/bin/env python3
"""
Script to check conversation history in both PostgreSQL and Redis.
"""

import asyncio
import asyncpg
import redis.asyncio as redis
import json
import uuid

async def check_postgres_history():
    """Check conversation history in PostgreSQL."""
    try:
        # Connect to PostgreSQL
        conn = await asyncpg.connect(
            host='localhost',
            port=5432,
            user='synapse_user',
            password='synapse_password',
            database='synapse_db'
        )
        
        # Get recent messages
        rows = await conn.fetch("""
            SELECT role, LEFT(content, 100) as content_preview, created_at, conversation_id
            FROM chat_messages 
            ORDER BY created_at DESC 
            LIMIT 20
        """)
        
        print("=== POSTGRESQL CHAT MESSAGES ===")
        print(f"Found {len(rows)} messages:")
        
        for row in rows:
            print(f"Role: {row['role']}, Content: {row['content_preview']}..., Time: {row['created_at']}, Conv: {row['conversation_id']}")
        
        # Group by conversation
        conv_rows = await conn.fetch("""
            SELECT conversation_id, role, COUNT(*) as count
            FROM chat_messages 
            GROUP BY conversation_id, role
            ORDER BY conversation_id, role
        """)
        
        print("\n=== MESSAGES BY CONVERSATION ===")
        for row in conv_rows:
            print(f"Conv: {row['conversation_id']}, Role: {row['role']}, Count: {row['count']}")
        
        await conn.close()
        
    except Exception as e:
        print(f"Error checking PostgreSQL: {e}")

async def check_redis_history():
    """Check conversation history in Redis."""
    try:
        # Connect to Redis
        redis_client = redis.Redis(host='localhost', port=6379, db=1, decode_responses=True)
        
        # Get all history keys
        keys = await redis_client.keys("history:*")
        print(f"\n=== REDIS CONVERSATION HISTORIES ===")
        print(f"Found {len(keys)} conversation histories:")
        
        for key in keys:
            conversation_id = key.replace("history:", "")
            history = await redis_client.lrange(key, 0, -1)
            print(f"\nConversation {conversation_id}: {len(history)} messages")
            
            # Show first few messages
            for i, msg_json in enumerate(history[:5]):
                try:
                    msg = json.loads(msg_json)
                    print(f"  {i+1}. Role: {msg.get('role', 'Unknown')}, Content: {msg.get('content', '')[:50]}...")
                except json.JSONDecodeError:
                    print(f"  {i+1}. Invalid JSON: {msg_json[:50]}...")
        
        await redis_client.close()
        
    except Exception as e:
        print(f"Error checking Redis: {e}")

async def main():
    await check_postgres_history()
    await check_redis_history()

if __name__ == "__main__":
    asyncio.run(main())
