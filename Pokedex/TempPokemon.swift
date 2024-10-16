import Foundation

struct TempPokemon: Codable {
    let id: Int
    let name: String
    let types: [String]
    var hp = 0
    var attack = 0
    var defense = 0
    var specialAttack = 0
    var specialDefense = 0
    var speed = 0
    let sprite: URL
    let shiny: URL

    enum PokemonKeys: String, CodingKey {
        case id // The id value is at the top level of the API
        case name // The name value is at the top level of the API
        case types // We need to go a couple levels deeper for the data
        case stats
        case sprites

        enum TypeDictionaryKeys: String, CodingKey {
            case type

            enum TypeKeys: String, CodingKey {
                case name
            }
        }

        enum StatDictionaryKeys: String, CodingKey {
            case value = "base_stat" // 'base_stat' matches the API key
            case stat // Since this case is not set equal to a string value, it will use the case name as the string value

            enum StatKeys: String, CodingKey {
                case name
            }
        }

        enum SpriteKeys: String, CodingKey {
            case sprite = "front_default"
            case shiny = "front_shiny"
        }
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        var decodedTypes: [String] = []

        // Grab the "types" array which is unkeyed from the API
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)

        // Loop through the array of types until the end is reached
        while !typesContainer.isAtEnd { // types[0], types[1], ...

            // Grab the keyed dictionary - types[x]
            var typesDictionaryContainer = try typesContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.self)

            // Grab the type container - type[x].type
            var typeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)

            // Grab the value of the type - type[x].type["name"]
            let type = try typeContainer.decode(String.self, forKey: .name)

            decodedTypes.append(type)
        }
        types = decodedTypes

        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)

        while !statsContainer.isAtEnd {
            let statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.self)

            var statValue = try statsDictionaryContainer.decode(Int.self, forKey: .value)

            let statContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.StatKeys.self, forKey: .stat)

            switch try statContainer.decode(String.self, forKey: .name) {
            case "hp":
                hp = statValue
            case "attack":
                attack = statValue
            case "defense":
                defense = statValue
            case "special-attack":
                specialAttack = statValue
            case "special-defense":
                specialDefense = statValue
            case "speed":
                speed = statValue
            default:
                print("It will never get here")
            }
        }

        var spritesContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)

        sprite = try spritesContainer.decode(URL.self, forKey: .sprite)
        shiny = try spritesContainer.decode(URL.self, forKey: .shiny)
    }
}
