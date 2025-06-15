import Foundation

struct Pokemon: Identifiable, Decodable {
    let id: Int
    let name: String
    let imageUrl: String
    let types: [String]
    let abilities: [String]
    let weight: Int
    let height: Int
    let baseExperience: Int
    let sprites: Sprites
    
    // Init para decodificação JSON (mantido)
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        weight = try container.decode(Int.self, forKey: .weight)
        height = try container.decode(Int.self, forKey: .height)
        baseExperience = try container.decode(Int.self, forKey: .baseExperience)
        
        sprites = try container.decode(Sprites.self, forKey: .sprites)
        imageUrl = sprites.frontDefault
        
        let typesArray = try container.decode([TypeElement].self, forKey: .types)
        types = typesArray.compactMap { $0.type.name }
        
        let abilitiesArray = try container.decode([AbilityElement].self, forKey: .abilities)
        abilities = abilitiesArray.compactMap { $0.ability.name }
    }
    
    // Novo init para criação manual, com valores básicos
    init(id: Int, name: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.types = []
        self.abilities = []
        self.weight = 0
        self.height = 0
        self.baseExperience = 0
        self.sprites = Sprites(frontDefault: imageUrl)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, sprites, types, abilities, weight, height
        case baseExperience = "base_experience"
    }
}

struct Sprites: Codable {
    let frontDefault: String
    
    private enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct TypeElement: Codable {
    let type: NamedAPIResource
}

struct AbilityElement: Codable {
    let ability: NamedAPIResource
}

struct NamedAPIResource: Codable {
    let name: String
}


