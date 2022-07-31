class Song

    attr_accessor :id, :name, :album

    def initialize(name:, album:, id: nil)
        @id = id
        @name = name
        @album = album
    end

    def self.create_table
        sql = <<-SQL
            CREATE TABLE IF NOT EXISTS songs (
                id INTEGER PRIMARY KEY,
                name TEXT,
                album TEXT
            )
        SQL

        DB[:conn].execute(sql)
    end

    def self.create(name:, album:)
        song = Song.new(name: name, album: album)
        song.save
    end

    def save
        sql = <<-SQL
            INSERT INTO songs (name, album)
            VALUES (?, ?)
        SQL

        DB[:conn].execute(sql, self.name, self.album)

        # Get the song ID from the database once the record has been saved
        # and assign it to the Ruby instance
        last_row = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")
        p last_row
        self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

        # Return the ruby instance
        self
    end

end

# song = Song.create(name: "New York", album: "Sinatra's Best")
