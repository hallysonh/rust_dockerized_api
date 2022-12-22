use std::net::SocketAddr;

use clap::Parser;

#[derive(Parser, Default, Debug)]
#[clap(author = "Hallyson Almeida", version, about)]
struct Arguments {
    #[clap(default_value = "127.0.0.1", short, long)]
    address: String,
    #[clap(default_value = "3030", short, long)]
    port: i32,
}

#[tokio::main]
async fn main() {
    let args = Arguments::parse();
    let addr: SocketAddr = format!("{}:{}", args.address, args.port)
        .parse()
        .expect("Unable to resolve domain");

    // run http server on above socket address
    rust_dockerized_api::httpserver::httpserver(addr).await;
}
