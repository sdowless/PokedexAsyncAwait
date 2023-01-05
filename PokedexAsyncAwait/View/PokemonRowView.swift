//
//  PokemonRowView.swift
//  PokedexAsyncAwait
//
//  Created by Stephan Dowless on 1/4/23.
//

import SwiftUI

struct PokemonRowView: View {
    let pokemon: Pokemon
    
    var body: some View {
        AsyncImage(url: pokemon.url) { image in
            HStack {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 88)
                    .padding(.trailing, 10)
                
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(pokemon.name.capitalized)
                        .font(.title3)
                    
                    Text("#\(pokemon.id)")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
            }
        } placeholder: {
            Color(.systemGray5)
        }
    }
}

struct PokemonRowView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonRowView(pokemon: Pokemon.sample)
    }
}
